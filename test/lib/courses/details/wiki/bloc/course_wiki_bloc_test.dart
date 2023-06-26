import 'package:bloc_test/bloc_test.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studipadawan/courses/details/wiki/bloc/course_wiki_bloc.dart';

class MockCourseRepository extends Mock implements CourseRepository {}

void main() {
  late MockCourseRepository mockedCourseRepository;

  setUp(() {
    mockedCourseRepository = MockCourseRepository();
  });

  CourseWikiPageData createWikiPage({
    required String id,
    required DateTime lastEditedAt,
    String? title,
  }) {
    return CourseWikiPageData(
      id: id,
      title: title ?? 'title $id',
      content: 'content $id',
      lastEditorAuthor: ItemAuthor(
        formattedName: 'some author $id',
        id: id,
        avatarUrl: '',
      ),
      lastEditedAt: lastEditedAt,
    );
  }

  group('onCourseWikiReloadRequested', () {
    blocTest<CourseWikiBloc, CourseWikiState>(
      'replace "WikiWikiWeb" with "Startseite"',
      setUp: () => when(
        () => mockedCourseRepository.getWikiPages(courseId: 'courseId1'),
      ).thenAnswer(
        (_) async => [
          createWikiPage(
            id: 'wikiPageId1',
            lastEditedAt: DateTime(2023, 5, 10),
            title: 'WikiWikiWeb',
          )
        ],
      ),
      build: () => CourseWikiBloc(
        courseId: 'courseId1',
        courseRepository: mockedCourseRepository,
      ),
      act: (bloc) => bloc.add(CourseWikiReloadRequested()),
      expect: () => [
        CourseWikiStateLoading(),
        CourseWikiStateDidLoad(
          wikiPages: [
            createWikiPage(
              id: 'wikiPageId1',
              lastEditedAt: DateTime(2023, 5, 10),
              title: 'Startseite',
            )
          ],
        )
      ],
    );

    blocTest<CourseWikiBloc, CourseWikiState>(
      'sort wiki pages based on last edit date',
      setUp: () => when(
        () => mockedCourseRepository.getWikiPages(courseId: 'courseId1'),
      ).thenAnswer(
        (_) async => [
          createWikiPage(
            id: 'wikiPageId1',
            lastEditedAt: DateTime(2023, 2, 2),
            title: 'wiki page old',
          ),
          createWikiPage(
            id: 'wikiPageId1',
            lastEditedAt: DateTime(2023, 3, 2),
            title: 'wiki page new',
          )
        ],
      ),
      build: () => CourseWikiBloc(
        courseId: 'courseId1',
        courseRepository: mockedCourseRepository,
      ),
      act: (bloc) => bloc.add(CourseWikiReloadRequested()),
      expect: () => [
        CourseWikiStateLoading(),
        CourseWikiStateDidLoad(
          wikiPages: [
            createWikiPage(
              id: 'wikiPageId1',
              lastEditedAt: DateTime(2023, 3, 2),
              title: 'wiki page new',
            ),
            createWikiPage(
              id: 'wikiPageId1',
              lastEditedAt: DateTime(2023, 2, 2),
              title: 'wiki page old',
            )
          ],
        )
      ],
    );

    blocTest<CourseWikiBloc, CourseWikiState>(
      'throw error if loading of wiki pages fails',
      setUp: () => when(
        () => mockedCourseRepository.getWikiPages(courseId: 'courseId1'),
      ).thenThrow("test error message, couldn't load wiki pages"),
      build: () => CourseWikiBloc(
        courseId: 'courseId1',
        courseRepository: mockedCourseRepository,
      ),
      act: (bloc) => bloc.add(CourseWikiReloadRequested()),
      expect: () => [
        CourseWikiStateLoading(),
        CourseWikiStateError(
          errorMessage:
              'Beim Laden der Wiki-Seiten ist ein Fehler aufgetreten.',
        )
      ],
    );
  });
}
