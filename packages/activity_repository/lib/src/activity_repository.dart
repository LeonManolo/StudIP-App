import 'package:activity_repository/src/models/file_activity.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:studip_api_client/studip_api_client.dart';

class ActivityRepository {
  const ActivityRepository({
    required StudIPActivityClient activityClient,
    required StudIPCoursesClient courseClient,
    required StudIPFilesClient filesClient,
  })  : _activityClient = activityClient,
        _courseClient = courseClient,
        _filesClient = filesClient;
  final StudIPActivityClient _activityClient;
  final StudIPCoursesClient _courseClient;
  final StudIPFilesClient _filesClient;

  Future<List<FileActivity>> getFileActivities(
      {required String userId, required int limit}) async {
    try {
      final fileActivityListResponse = await _activityClient.getFileActivities(
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
            await _filesClient.getFileRef(fileId: fileActivity.fileId);
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
      final courseResponse = await _courseClient.getCourse(courseId: courseId);
      return Course.fromCourseResponse(courseResponse);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
}
