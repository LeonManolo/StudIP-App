import '../models/models.dart';

abstract class StudIPCoursesClient {
  Future<CourseListResponse> getCourses(
      {required String userId, required int offset, required int limit});
  Future<SemesterResponse> getSemester(String semesterId);
  Future<CourseNewsListResponse> getCourseNews(
      {required String courseId, required int limit});
  Future<CourseEventListResponse> getCourseEvents(
      {required String courseId, required int offset, required int limit});
}
