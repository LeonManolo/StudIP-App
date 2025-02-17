import 'package:courses_repository/src/models/models.dart';
import 'package:studip_api_client/studip_api_client.dart'
    hide CourseNewsListResponse, CourseWikiPageListResponse;

class CourseRepository {
  const CourseRepository({
    required StudIPCoursesClient coursesApiClient,
    required StudIPUserClient userApiClient,
  })  : _coursesApiClient = coursesApiClient,
        _userApiClient = userApiClient;

  final StudIPCoursesClient _coursesApiClient;
  final StudIPUserClient _userApiClient;

  Future<List<StudIPCourseEventItem>> getCourseEvents({
    required String courseId,
  }) async {
    try {
      final List<CourseEventResponseItem> eventsResponseItems =
          await _getResponse<CourseEventResponseItem>(
        id: courseId,
        loadItems: ({required id, required limit, required offset}) async {
          return _coursesApiClient.getCourseEvents(
            courseId: courseId,
            offset: offset,
            limit: limit,
          );
        },
      );

      return eventsResponseItems
          .map(
            (item) =>
                StudIPCourseEventItem.fromCourseEventResponseItem(item: item),
          )
          .toList();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<CourseNewsListResponse> getCourseNews({
    required String courseId,
    required int limit,
    required int offset,
  }) async {
    try {
      final newsResponse = await _coursesApiClient.getCourseNews(
        courseId: courseId,
        limit: limit,
        offset: offset,
      );

      final List<CourseNews> newsItems = await Future.wait(
        newsResponse.items.map((rawNewsResponse) async {
          final UserResponse userResponse =
              await _userApiClient.getUser(userId: rawNewsResponse.authorId);
          return CourseNews.fromCourseNewsResponse(
            courseNewsResponse: rawNewsResponse,
            userResponseItem: userResponse.userResponseItem,
          );
        }),
      );

      return CourseNewsListResponse(
        totalNumberOfNews: newsResponse.total,
        news: newsItems,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<List<CourseWikiPageData>> getWikiPages({
    required String courseId,
  }) async {
    try {
      final List<CourseWikiPageResponseItem> wikiPagesResponse =
          await _getResponse(
        id: courseId,
        loadItems: ({required id, required limit, required offset}) async {
          return _coursesApiClient.getCourseWikiPages(
            courseId: courseId,
            offset: offset,
            limit: limit,
          );
        },
      );

      return await Future.wait(
        wikiPagesResponse.map((rawWikiPage) async {
          final userResponse =
              await _userApiClient.getUser(userId: rawWikiPage.lastEditorId);
          return CourseWikiPageData.fromCourseWikiPageResponse(
            courseWikiPageResponse: rawWikiPage,
            userResponseItem: userResponse.userResponseItem,
          );
        }),
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<List<Semester>> getCoursesGroupedBySemester(String userId) async {
    try {
      final List<CourseResponseItem> courses = await _getResponse(
        id: userId,
        loadItems: ({required id, required limit, required offset}) async {
          return _coursesApiClient.getCourses(
            userId: id,
            offset: offset,
            limit: limit,
          );
        },
      );

      final Map<String, List<CourseResponseItem>> semesterToCourses = {};
      for (final course in courses) {
        if (semesterToCourses.containsKey(course.startSemesterId)) {
          semesterToCourses[course.startSemesterId]?.add(course);
        } else {
          semesterToCourses[course.startSemesterId] = [course];
        }
      }

      final semestersResponse = await Future.wait(
        semesterToCourses.keys.map(
          (semesterId) => _coursesApiClient.getSemester(semesterId: semesterId),
        ),
      );

      final semesters = semestersResponse.map((semesterResponse) {
        return Semester.fromSemesterResponse(
          semesterResponseItem: semesterResponse.semester,
          courses: semesterToCourses[semesterResponse.semester.id]
                  ?.map(
                    Course.fromCourseResponseItem,
                  )
                  .toList() ??
              [],
        );
      }).toList();

      return semesters
        ..sort(
          (semester1, semester2) => semester2.start.compareTo(semester1.start),
        );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<Course> getCourse({required String courseId}) async {
    final courseResponse =
        await _coursesApiClient.getCourse(courseId: courseId);
    return Course.fromCourseResponseItem(courseResponse.courseResponseItem);
  }

  Future<CourseParticipantsData> getCourseParticipants({
    required String courseId,
    required int offset,
    required int limit,
  }) async {
    final participantsResponse = await _coursesApiClient.getCourseParticipants(
      courseId: courseId,
      offset: offset,
      limit: limit,
    );
    final participants = <Participant>[];
    for (final participantResponse in participantsResponse.participants) {
      final UserResponse userResponse =
          await _userApiClient.getUser(userId: participantResponse.id);
      participants
          .add(Participant.fromUserResponseItem(userResponse.userResponseItem));
    }

    return CourseParticipantsData(
      participants: participants,
      totalParticipants: participantsResponse.meta.page.total,
    );
  }

  // ***** Private Helpers *****

  /// This method can be used to recursively fetch all items.
  Future<List<I>> _getResponse<I>({
    required String id,
    int limit = 30,
    int offset = 0,
    required Future<ItemListResponse<I>> Function({
      required String id,
      required int limit,
      required int offset,
    }) loadItems,
  }) async {
    final response = await loadItems(id: id, limit: limit, offset: offset);
    if (response.total > limit && (response.offset + limit) < response.total) {
      final itemsResponse = response.items;
      return itemsResponse
        ..addAll(
          await _getResponse(
            id: id,
            limit: limit,
            offset: offset + limit,
            loadItems: loadItems,
          ),
        );
    } else {
      return response.items;
    }
  }
}
