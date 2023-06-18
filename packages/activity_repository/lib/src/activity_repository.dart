import 'package:activity_repository/activity_repository.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:studip_api_client/studip_api_client.dart';

class ActivityRepository {
  const ActivityRepository({
    required StudIPActivityClient activityClient,
    required StudIPCoursesClient courseClient,
    required StudIPFilesClient filesClient,
    required StudIPUserClient userClient,
  })  : _activityClient = activityClient,
        _courseClient = courseClient,
        _filesClient = filesClient,
        _userClient = userClient;
  final StudIPActivityClient _activityClient;
  final StudIPCoursesClient _courseClient;
  final StudIPUserClient _userClient;
  final StudIPFilesClient _filesClient;

  Future<List<FileActivity>> getFileActivities({
    required String userId,
    required int limit,
  }) async {
    try {
      final fileActivityListResponse = await _activityClient.getFileActivities(
        userId: userId,
        limit: limit,
      );
      final fileActivities = fileActivityListResponse.fileActivities
          .map(
            (fileActivityResponse) => FileActivity.fromFileActivityResponse(
              fileActivityResponse: fileActivityResponse,
            ),
          )
          .toList();

      for (final fileActivity in fileActivities) {
        final course = await getCourse(
          courseId: fileActivity.courseId,
        );
        final fileRef =
            await _filesClient.getFileRef(fileId: fileActivity.fileId);
        fileActivity
          ..course = course
          ..owner = fileRef.owner
          ..fileName = fileRef.name;
      }
      return fileActivities;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<List<NewsActivity>> getNewsActivities({
    required String userId,
    required int limit,
  }) async {
    try {
      final newsActivityListResponse = await _activityClient.getNewsActivities(
        userId: userId,
        limit: limit,
      );

      final newsActivities = newsActivityListResponse.newsActivities
          .map(
            (newsActivityResponse) => NewsActivity.fromNewsActivityResponse(
              newsActivityResponse: newsActivityResponse,
            ),
          )
          .toList();
      for (final newsActivity in newsActivities) {
        final course = await getCourse(
          courseId: newsActivity.courseId,
        );
        final user = await _userClient.getUser(userId: newsActivity.userId);
        newsActivity
          ..userName = user.formattedName
          ..course = course;
      }
      return newsActivities;
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
