import 'package:studip_api_client/src/models/courses/course_participants_response.dart';

import '../models/models.dart';

abstract class StudIPCoursesClient {
  Future<CourseListResponse> getCourses({
    required String userId,
    required int offset,
    required int limit,
  });

  Future<SemesterResponse> getSemester({required String semesterId});

  Future<CourseNewsListResponse> getCourseNews(
      {required String courseId, required int limit, required int offset});

  Future<CourseEventListResponse> getCourseEvents({
    required String courseId,
    required int offset,
    required int limit,
  });

  Future<UserResponse> getUser({required String userId});

  Future<CourseWikiPagesListResponse> getCourseWikiPages({
    required String courseId,
    required int offset,
    required int limit,
  });

  Future<CourseParticipantsResponse> getCourseParticipants({
    required String courseId,
    required int offset,
    required int limit,
  });
}
