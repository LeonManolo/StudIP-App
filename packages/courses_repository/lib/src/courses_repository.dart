import 'package:courses_repository/src/models/semester.dart';
import 'package:courses_repository/src/models/course.dart';
import 'package:studip_api_client/studip_api_client.dart';

class CourseRepository {
  final StudIpApiClient _apiClient;

  const CourseRepository({
    required StudIpApiClient apiClient,
  }) : _apiClient = apiClient;

  Future<List<Semester>> getCoursesGroupedBySemester(String userId) async {
    try {
      final response = await _apiClient.getCourses(userId);
      final courses = response.courses;
      Map<String, List<CourseResponse>> semesterToCourses = {};
      for (var course in courses) {
        if (semesterToCourses.containsKey(course.semesterId)) {
          semesterToCourses[course.semesterId]?.add(course);
        } else {
          semesterToCourses[course.semesterId] = [course];
        }
      }

      final semestersResponse = await Future.wait(semesterToCourses.keys
          .map((semesterId) => _apiClient.getSemester(semesterId)));

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
}
