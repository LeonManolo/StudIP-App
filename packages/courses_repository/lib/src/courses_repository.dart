import 'package:courses_repository/src/models/models.dart';
import 'package:studip_api_client/studip_api_client.dart';

class CourseRepository {
  final StudIPCoursesClient _apiClient;

  const CourseRepository({
    required StudIPCoursesClient apiClient,
  }) : _apiClient = apiClient;

  Future<List<StudIPCourseEvent>> getCourseEvents(
      {required String courseId}) async {
    try {
      final eventsResponse =
          await _getCourseEvents(courseId: courseId, limit: 30, offset: 0);
      return eventsResponse
          .map((eventResponse) => StudIPCourseEvent.fromCourseEventResponse(
              courseEventResponse: eventResponse))
          .toList();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<List<CourseNews>> getCourseNews(
      {required String courseId, required int limit}) async {
    try {
      final newsResponse =
          await _apiClient.getCourseNews(courseId: courseId, limit: limit);
      return newsResponse.news
          .map((newsResponse) => CourseNews.fromCourseNewsResponse(
              courseNewsResponse: newsResponse))
          .toList();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<List<Semester>> getCoursesGroupedBySemester(String userId) async {
    try {
      final courses = await _getCourses(userId: userId, limit: 30, offset: 0);

      Map<String, List<CourseResponse>> semesterToCourses = {};
      for (var course in courses) {
        if (semesterToCourses.containsKey(course.semesterId)) {
          semesterToCourses[course.semesterId]?.add(course);
        } else {
          semesterToCourses[course.semesterId] = [course];
        }
      }

      final semestersResponse = await Future.wait(semesterToCourses.keys
          .map((semesterId) => _apiClient.getSemester(semesterId: semesterId)));

      final semesters = semestersResponse.map((semesterResponse) {
        return Semester.fromSemesterResponse(
          semesterResponse: semesterResponse,
          courses: semesterToCourses[semesterResponse.id]
                  ?.map((courseResponse) =>
                      Course.fromCourseResponse(courseResponse))
                  .toList() ??
              [],
        );
      }).toList();

      semesters.sort(
          (semester1, semester2) => semester2.start.compareTo(semester1.start));
      return semesters;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<List<CourseResponse>> _getCourses({
    required String userId,
    required int limit,
    required int offset,
  }) async {
    final response = await _apiClient.getCourses(
        userId: userId, limit: limit, offset: offset);

    if (response.total > limit && (response.offset + limit) < response.total) {
      var courseResponses = response.courses;
      courseResponses.addAll(await _getCourses(
          userId: userId, limit: limit, offset: offset + limit));

      return courseResponses;
    } else {
      return response.courses;
    }
  }

  Future<List<CourseEventResponse>> _getCourseEvents(
      {required String courseId,
      required int limit,
      required int offset}) async {
    final response = await _apiClient.getCourseEvents(
        courseId: courseId, offset: offset, limit: limit);

    if (response.total > limit && (response.offset + limit) < response.total) {
      var eventResponse = response.events;
      eventResponse.addAll(await _getCourseEvents(
          courseId: courseId, limit: limit, offset: offset + limit));
      return eventResponse;
    } else {
      return response.events;
    }
  }
}
