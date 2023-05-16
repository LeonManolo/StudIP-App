import 'package:courses_repository/courses_repository.dart'
    hide CourseNewsListResponse;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studip_api_client/studip_api_client.dart';

class MockStudIPCoursesClient extends Mock implements StudIPCoursesClient {}

void main() {
  late CourseRepository sut;
  late MockStudIPCoursesClient mockedApiClient;

  setUp(() {
    mockedApiClient = MockStudIPCoursesClient();
    sut = CourseRepository(apiClient: mockedApiClient);
  });

  group('getCourseEvents', () {
    CourseEventResponse generateCourseEventResponse({required int id}) {
      return CourseEventResponse(
        id: '$id',
        title: 'title $id',
        description: 'description $id',
        start: '2023-04-13T11:30:00+02:00',
        end: '2023-04-13T11:30:00+02:00',
        categories: [],
      );
    }

    test('handle multi page request', () async {
      when(() => mockedApiClient.getCourseEvents(
          courseId: '1', offset: 0, limit: 30)).thenAnswer((_) async {
        return CourseEventListResponse(
          events: List.generate(
            30,
            (index) => generateCourseEventResponse(id: index),
          ),
          offset: 0,
          limit: 30,
          total: 50,
        );
      });
      when(
        () => mockedApiClient.getCourseEvents(
          courseId: '1',
          offset: 30,
          limit: 30,
        ),
      ).thenAnswer((_) async {
        return CourseEventListResponse(
          events: List.generate(
            20,
            (index) => generateCourseEventResponse(id: 30 + index),
          ),
          offset: 30,
          limit: 30,
          total: 50,
        );
      });

      final List<StudIPCourseEvent> courseEvents =
          await sut.getCourseEvents(courseId: '1');

      expect(
        courseEvents.map((courseEvent) => courseEvent.title),
        List.generate(50, (index) => 'title $index'),
      );
    });
  });

  group('getCourseNews', () {
    CourseNewsResponse generateCoursNewsResponse({required int id}) {
      return CourseNewsResponse(
        id: '$id',
        title: 'title $id',
        content: 'content $id',
        publicationStart: '2023-04-13T11:30:00+02:00',
        publicationEnd: '2023-04-20T11:30:00+02:00',
        authorId: '$id',
      );
    }

    UserResponse generateUserResponse({required String id}) {
      return UserResponse(
        id: 'userId_$id',
        username: 'username_$id',
        formattedName: 'formattedName_$id',
        familyName: '',
        givenName: 'givenName',
        permission: 'author',
        email: '',
        phone: '',
        homepage: null,
        address: null,
        avatarUrl: 'avatarUrl_$id',
      );
    }

    test('get last 5 course news', () async {
      when(
        () => mockedApiClient.getUser(
          userId: any(named: 'userId', that: isNotNull),
        ),
      ).thenAnswer(
        (invocation) async => generateUserResponse(
          id: invocation.namedArguments[const Symbol('userId')] as String,
        ),
      );
      when(
        () => mockedApiClient.getCourseNews(courseId: '1', limit: 5, offset: 0),
      ).thenAnswer((_) async {
        return CourseNewsListResponse(
          news: List.generate(
            3,
            (index) => generateCoursNewsResponse(id: index),
          ),
          offset: 0,
          limit: 5,
          total: 3,
        );
      });

      final courseNewsResponse =
          await sut.getCourseNews(courseId: '1', limit: 5, offset: 0);

      for (var i = 0; i < courseNewsResponse.news.length; i++) {
        final courseNews = courseNewsResponse.news.elementAt(i);

        expect(courseNews.title, 'title $i');
        expect(courseNews.author.avatarUrl, 'avatarUrl_$i');
        expect(courseNews.author.formattedName, 'formattedName_$i');
        expect(courseNews.author.id, 'userId_$i');
      }
    });
  });

  group('getCoursesGroupedBySemester', () {
    CourseResponse generateCourseResponse({
      required int courseId,
      required int semesterId,
    }) {
      return CourseResponse(
        id: '$courseId',
        detailsResponse: CourseDetailsResponse(title: 'details'),
        semesterId: '$semesterId',
      );
    }

    SemesterResponse generateSemesterResponse({
      required int id,
      required String semesterStart,
      required String semesterEnd,
    }) {
      return SemesterResponse(
        id: '$id',
        title: 'title $id',
        description: 'description $id',
        start: semesterStart,
        end: semesterEnd,
        startOfLectures: '2022-05-13T11:30:00+02:00',
        endOfLectures: '2023-02-20T11:30:00+02:00',
      );
    }

    final List<Map<String, String>> semesterRawDates = [
      {
        'start': '2020-01-13T11:30:00+02:00',
        'end': '2020-06-13T11:30:00+02:00'
      },
      {
        'start': '2020-06-14T11:30:00+02:00',
        'end': '2020-12-29T11:30:00+02:00'
      },
      {'start': '2020-12-30T11:30:00+02:00', 'end': '2021-06-13T11:30:00+02:00'}
    ];

    final List<CourseResponse> courses = List.generate(
      35,
      (index) => generateCourseResponse(courseId: index, semesterId: index % 3),
    );

    test('courses which belong to same semester are grouped together',
        () async {
      when(() => mockedApiClient.getCourses(userId: '1', offset: 0, limit: 30))
          .thenAnswer((_) async {
        return CourseListResponse(
          courses: courses.getRange(0, 30).toList(),
          offset: 0,
          limit: 30,
          total: 35,
        );
      });
      when(() => mockedApiClient.getCourses(userId: '1', offset: 30, limit: 30))
          .thenAnswer((_) async {
        return CourseListResponse(
          courses: courses.getRange(30, 35).toList(),
          offset: 30,
          limit: 30,
          total: 35,
        );
      });
      when(
        () => mockedApiClient.getSemester(
          semesterId: any(that: isNotNull, named: 'semesterId'),
        ),
      ).thenAnswer((invocation) async {
        final invokedIndex = int.parse(
          invocation.namedArguments[const Symbol('semesterId')] as String,
        );
        return generateSemesterResponse(
          id: invokedIndex,
          semesterStart: semesterRawDates[invokedIndex]['start'] ?? '',
          semesterEnd: semesterRawDates[invokedIndex]['end'] ?? '',
        );
      });

      final List<Semester> semesters =
          await sut.getCoursesGroupedBySemester('1');

      // Assert
      expect(semesters.length, 3);
      expect(semesters[0].id, '2');
      expect(
        semesters[0].courses.map((course) => course.id),
        courses
            .where((course) => course.semesterId == '2')
            .map((course) => course.id),
      );

      expect(semesters[1].id, '1');
      expect(
        semesters[1].courses.map((course) => course.id),
        courses
            .where((course) => course.semesterId == '1')
            .map((course) => course.id),
      );

      expect(semesters[2].id, '0');
      expect(
        semesters[2].courses.map((course) => course.id),
        courses
            .where((course) => course.semesterId == '0')
            .map((course) => course.id),
      );
    });
  });
}
