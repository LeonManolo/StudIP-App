import 'package:courses_repository/courses_repository.dart'
    hide CourseNewsListResponse;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studip_api_client/studip_api_client.dart';

class MockStudIPCoursesClient extends Mock implements StudIPCoursesClient {}

class MockStudIPUserClient extends Mock implements StudIPUserClient {}

void main() {
  late CourseRepository sut;
  late MockStudIPCoursesClient mockedCoursesClient;
  late MockStudIPUserClient mockedUserClient;

  setUp(() {
    mockedCoursesClient = MockStudIPCoursesClient();
    mockedUserClient = MockStudIPUserClient();
    sut = CourseRepository(
      coursesApiClient: mockedCoursesClient,
      userApiClient: mockedUserClient,
    );
  });

  group('getCourseEvents', () {
    CourseEventResponseItem generateCourseEventResponseItems(
        {required int id}) {
      return CourseEventResponseItem(
        '$id',
        CourseEventResponseItemAttributes(
          'title $id',
          'description $id',
          '2023-04-13T11:30:00+02:00',
          '2023-04-13T11:30:00+02:00',
          [],
          '',
        ),
      );
    }

    test('handle multi page request', () async {
      when(
        () => mockedCoursesClient.getCourseEvents(
          courseId: '1',
          offset: any(named: 'offset'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((invocation) async {
        final int passedOffset =
            invocation.namedArguments[const Symbol('offset')] as int;
        final CourseEventResponsePage page = CourseEventResponsePage(
          passedOffset,
          30,
          50,
        );

        return CourseEventResponse(
          CourseEventResponseMeta(page),
          List.generate(
            passedOffset == 0 ? 30 : 20,
            (index) => generateCourseEventResponseItems(
              id: (passedOffset == 0 ? 0 : 30) +
                  index, // add 30 for second batch to increment id correctly
            ),
          ),
        );
      });

      final List<StudIPCourseEventItem> courseEvents =
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
        namePrefix: '',
        nameSuffix: '',
      );
    }

    test('get last 5 course news', () async {
      when(
        () => mockedUserClient.getUser(
          userId: any(named: 'userId', that: isNotNull),
        ),
      ).thenAnswer(
        (invocation) async => generateUserResponse(
          id: invocation.namedArguments[const Symbol('userId')] as String,
        ),
      );
      when(
        () => mockedCoursesClient.getCourseNews(
          courseId: '1',
          limit: 5,
          offset: 0,
        ),
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

      for (var i = 0; i < 5; i++) {
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
      when(
        () => mockedCoursesClient.getCourses(userId: '1', offset: 0, limit: 30),
      ).thenAnswer((_) async {
        return CourseListResponse(
          courses: courses.getRange(0, 30).toList(),
          offset: 0,
          limit: 30,
          total: 35,
        );
      });
      when(
        () => mockedCoursesClient.getCourses(
          userId: '1',
          offset: 30,
          limit: 30,
        ),
      ).thenAnswer((_) async {
        return CourseListResponse(
          courses: courses.getRange(30, 35).toList(),
          offset: 30,
          limit: 30,
          total: 35,
        );
      });
      when(
        () => mockedCoursesClient.getSemester(
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
