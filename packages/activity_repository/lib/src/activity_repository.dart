import 'package:activity_repository/src/models/file_activity.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:studip_api_client/studip_api_client.dart';

class ActivityRepository {
  const ActivityRepository({required StudIPActivityClient apiClient})
      : _apiClient = apiClient;
  final StudIPActivityClient _apiClient;

  Future<List<FileActivity>> getFileActivities(
      {required String userId, required int limit}) async {
    try {
      final fileActivityListResponse = await _apiClient.getFileActivities(
        userId: userId,
        limit: limit,
      );
      final fileActivities = fileActivityListResponse.fileActivities
          .map((fileActivityResponse) => FileActivity.fromFileActivityResponse(
              fileActivityResponse: fileActivityResponse))
          .toList();

      for (var fileActivity in fileActivities) {
        final course = await getCourse(
          courseId: fileActivity.courseId,
        );
        final fileRef =
            await _apiClient.getFileRef(fileId: fileActivity.fileId);
        fileActivity.course = course;
        fileActivity.owner = fileRef.owner;
        fileActivity.fileName = fileRef.name;
      }
      return fileActivities;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<Course> getCourse({
    required String courseId,
  }) async {
    try {
      final courseResponse = await _apiClient.getCourse(courseId: courseId);
      return Course.fromCourseResponse(courseResponse);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
}
