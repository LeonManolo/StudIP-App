import 'package:bloc_test/bloc_test.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studipadawan/courses/details/news/bloc/course_news_bloc.dart';

class MockCourseRepository extends Mock implements CourseRepository {}

void main() {
  const courseId = '1';
  late MockCourseRepository mockedCourseRepository;

  setUp(() {
    mockedCourseRepository = MockCourseRepository();
  });

  CourseNews createCourseNews({required String id}) {
    return CourseNews(
      id: id,
      title: 'news $id',
      content: 'content $id',
      publicationStart: DateTime(2023, 2, 3).toLocal(),
      publicationEnd: DateTime(2023, 3, 4).toLocal(),
      author: ItemAuthor(
        id: 'author $id',
        avatarUrl: '',
        formattedName: '',
      ),
    );
  }

  blocTest<CourseNewsBloc, CourseNewsState>(
    'Initial state',
    build: () => CourseNewsBloc(
      courseRepository: mockedCourseRepository,
      courseId: courseId,
    ),
    verify: (bloc) {
      final expectedState = CourseNewsStateLoading();
      expect(bloc.state, expectedState);
    },
  );

  group('CourseNewsReloadRequested', () {
    final courseNews1 = createCourseNews(id: '1');
    blocTest<CourseNewsBloc, CourseNewsState>(
      'Did load news with success',
      setUp: () => when(
        () => mockedCourseRepository.getCourseNews(
          courseId: courseId,
          limit: 20,
          offset: 0,
        ),
      ).thenAnswer(
        (_) async => CourseNewsListResponse(
          totalNumberOfNews: 1,
          news: [courseNews1],
        ),
      ),
      build: () => CourseNewsBloc(
        courseRepository: mockedCourseRepository,
        courseId: courseId,
        limit: 20,
      ),
      act: (bloc) => bloc.add(CourseNewsReloadRequested()),
      expect: () => [
        CourseNewsStateLoading(),
        CourseNewsStateDidLoad(
          news: [courseNews1],
          maxReached: true,
          paginationLoading: false,
        )
      ],
    );

    blocTest<CourseNewsBloc, CourseNewsState>(
      'Did load news with error',
      setUp: () => when(
        () => mockedCourseRepository.getCourseNews(
          courseId: courseId,
          limit: 15,
          offset: 0,
        ),
      ).thenThrow('generic error message'),
      build: () => CourseNewsBloc(
        courseRepository: mockedCourseRepository,
        courseId: courseId,
        limit: 15,
      ),
      act: (bloc) => bloc.add(CourseNewsReloadRequested()),
      expect: () => [
        CourseNewsStateLoading(),
        CourseNewsStateError(
          errorMessage:
              'Beim Laden der Ankündigungen ist ein Fehler aufgetreten.',
        ),
      ],
    );
  });

  group('CourseNewsReachedBottom', () {
    final courseNews1 = createCourseNews(id: '1');
    final courseNews2 = createCourseNews(id: '2');
    final courseNews3 = createCourseNews(id: '3');
    final courseNews4 = createCourseNews(id: '4');
    blocTest<CourseNewsBloc, CourseNewsState>(
      'Load successful more items with pagination',
      setUp: () {
        when(
          () => mockedCourseRepository.getCourseNews(
            courseId: '1',
            limit: 2,
            offset: 0,
          ),
        ).thenAnswer(
          (_) async => CourseNewsListResponse(
            totalNumberOfNews: 4,
            news: [courseNews1, courseNews2],
          ),
        );

        when(
          () => mockedCourseRepository.getCourseNews(
            courseId: '1',
            limit: 2,
            offset: 2,
          ),
        ).thenAnswer(
          (_) async => CourseNewsListResponse(
            totalNumberOfNews: 4,
            news: [courseNews3, courseNews4],
          ),
        );
      },
      build: () => CourseNewsBloc(
        courseRepository: mockedCourseRepository,
        courseId: courseId,
        limit: 2,
      ),
      act: (bloc) {
        bloc
          ..add(CourseNewsReloadRequested())
          ..add(CourseNewsReachedBottom());
      },
      expect: () => [
        CourseNewsStateLoading(),
        CourseNewsStateDidLoad(
          news: [courseNews1, courseNews2],
          maxReached: false,
          paginationLoading: false,
        ),
        CourseNewsStateDidLoad(
          news: [courseNews1, courseNews2],
          maxReached: false,
          paginationLoading: true,
        ),
        CourseNewsStateDidLoad(
          news: [courseNews1, courseNews2, courseNews3, courseNews4],
          maxReached: true,
          paginationLoading: false,
        ),
      ],
    );

    blocTest<CourseNewsBloc, CourseNewsState>(
      'Load more items with pagination failure',
      setUp: () {
        when(
          () => mockedCourseRepository.getCourseNews(
            courseId: '1',
            limit: 2,
            offset: 0,
          ),
        ).thenAnswer(
          (_) async => CourseNewsListResponse(
            totalNumberOfNews: 4,
            news: [courseNews1, courseNews2],
          ),
        );

        when(
          () => mockedCourseRepository.getCourseNews(
            courseId: '1',
            limit: 2,
            offset: 2,
          ),
        ).thenThrow('generic error occured');
      },
      build: () => CourseNewsBloc(
        courseRepository: mockedCourseRepository,
        courseId: courseId,
        limit: 2,
      ),
      act: (bloc) {
        bloc
          ..add(CourseNewsReloadRequested())
          ..add(CourseNewsReachedBottom());
      },
      expect: () => [
        CourseNewsStateLoading(),
        CourseNewsStateDidLoad(
          news: [courseNews1, courseNews2],
          maxReached: false,
          paginationLoading: false,
        ),
        CourseNewsStateDidLoad(
          news: [courseNews1, courseNews2],
          maxReached: false,
          paginationLoading: true,
        ),
        CourseNewsStateError(
          errorMessage:
              'Beim Laden der Ankündigungen ist ein Fehler aufgetreten.',
        )
      ],
    );
  });
}
