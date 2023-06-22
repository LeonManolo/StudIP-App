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
    CourseEventResponseItem generateCourseEventResponseItems({
      required int id,
    }) {
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

    final List<CourseEventResponseItem> events = List.generate(
      50,
      (index) => generateCourseEventResponseItems(id: index),
    );

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
        final ResponsePage page = ResponsePage(
          offset: passedOffset,
          limit: 30,
          total: 50,
        );

        return CourseEventResponse(
          ResponseMeta(page: page),
          (passedOffset == 0 ? events.getRange(0, 30) : events.getRange(30, 50))
              .toList(),
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
    CourseNewsResponseItem generateCoursNewsResponseItem({
      required int id,
    }) {
      return CourseNewsResponseItem(
        id: '$id',
        attributes: CourseNewsResponseItemAttributes(
          title: 'title $id',
          content: 'content $id',
          publicationStart: '2023-04-13T11:30:00+02:00',
          publicationEnd: '2023-04-20T11:30:00+02:00',
        ),
        relationships: CourseNewsResponseItemRelationships(
          author: CourseNewsResponseItemRelationshipAuthor(
            data: CourseNewsResponseItemRelationshipAuthorData(
              type: 'user',
              id: '$id',
            ),
          ),
        ),
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
        return CourseNewsResponse(
            meta: ResponseMeta(
              page: ResponsePage(
                offset: 0,
                limit: 5,
                total: 3,
              ),
            ),
            items: List.generate(
                3, (index) => generateCoursNewsResponseItem(id: index)));
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
    CourseResponseItem generateCourseResponse({
      required int courseId,
      required int semesterId,
    }) {
      return CourseResponseItem(
        id: '$courseId',
        attributes: CourseResponseItemAttributes(title: 'details'),
        relationships: CourseResponseItemRelationships(
          startSemester: CourseResponseItemRelationshipsSemester(
            data: CourseResponseItemRelationshipsSemesterData(
              id: '$semesterId',
              type: 'semesters',
            ),
          ),
          endSemester: CourseResponseItemRelationshipsSemester(
            data: CourseResponseItemRelationshipsSemesterData(
              id: '-1', // end semester is not relevant
              type: 'semesters',
            ),
          ),
        ),
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

    final List<CourseResponseItem> courses = List.generate(
      35,
      (index) => generateCourseResponse(courseId: index, semesterId: index % 3),
    );

    test('courses which belong to same semester are grouped together',
        () async {
      when(
        () => mockedCoursesClient.getCourses(
          userId: '1',
          offset: any(named: 'offset'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((invocation) async {
        final int passedOffset =
            invocation.namedArguments[const Symbol('offset')] as int;

        return CourseResponse(
          courses: (passedOffset == 0
                  ? courses.getRange(0, 30)
                  : courses.getRange(30, 35))
              .toList(),
          meta: ResponseMeta(
            page: ResponsePage(
              offset: passedOffset,
              limit: 30,
              total: 35,
            ),
          ),
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
            .where((course) => course.startSemesterId == '2')
            .map((course) => course.id),
      );

      expect(semesters[1].id, '1');
      expect(
        semesters[1].courses.map((course) => course.id),
        courses
            .where((course) => course.startSemesterId == '1')
            .map((course) => course.id),
      );

      expect(semesters[2].id, '0');
      expect(
        semesters[2].courses.map((course) => course.id),
        courses
            .where((course) => course.startSemesterId == '0')
            .map((course) => course.id),
      );
    });
  });
}
