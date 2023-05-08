import 'package:courses_repository/src/models/models.dart';
import 'package:studip_api_client/studip_api_client.dart';

class CourseRepository {
  const CourseRepository({
    required StudIPCoursesClient apiClient,
  }) : _apiClient = apiClient;
  final StudIPCoursesClient _apiClient;

  Future<List<StudIPCourseEvent>> getCourseEvents({
    required String courseId,
  }) async {
    try {
      final List<CourseEventResponse> eventsResponse =
          await _getResponse<CourseEventResponse>(
        id: courseId,
        loadItems: ({required id, required limit, required offset}) async {
          return _apiClient.getCourseEvents(
            courseId: id,
            offset: offset,
            limit: limit,
          );
        },
      );

      return eventsResponse
          .map(
            (eventResponse) => StudIPCourseEvent.fromCourseEventResponse(
              courseEventResponse: eventResponse,
            ),
          )
          .toList();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<List<CourseNews>> getCourseNews({
    required String courseId,
    required int limit,
  }) async {
    try {
      final newsResponse =
          await _apiClient.getCourseNews(courseId: courseId, limit: limit);
      return newsResponse.news
          .map(
            (newsResponse) => CourseNews.fromCourseNewsResponse(
              courseNewsResponse: newsResponse,
            ),
          )
          .toList();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<List<Semester>> getCoursesGroupedBySemester(String userId) async {
    try {
      final List<CourseResponse> courses = await _getResponse(
        id: userId,
        loadItems: ({required id, required limit, required offset}) async {
          return _apiClient.getCourses(
            userId: id,
            offset: offset,
            limit: limit,
          );
        },
      );

      final Map<String, List<CourseResponse>> semesterToCourses = {};
      for (final course in courses) {
        if (semesterToCourses.containsKey(course.semesterId)) {
          semesterToCourses[course.semesterId]?.add(course);
        } else {
          semesterToCourses[course.semesterId] = [course];
        }
      }

      final semestersResponse = await Future.wait(
        semesterToCourses.keys.map(
          (semesterId) => _apiClient.getSemester(semesterId: semesterId),
        ),
      );

      final semesters = semestersResponse.map((semesterResponse) {
        return Semester.fromSemesterResponse(
          semesterResponse: semesterResponse,
          courses: semesterToCourses[semesterResponse.id]
                  ?.map(
                    Course.fromCourseResponse,
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
    })
        loadItems,
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
