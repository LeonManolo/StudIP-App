import 'package:activity_repository/activity_repository.dart';
import 'package:studip_api_client/studip_api_client.dart';

class ActivityRepository {
  const ActivityRepository({
    required StudIPActivityClient activityClient,
  }) : _activityClient = activityClient;
  final StudIPActivityClient _activityClient;

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
      return fileActivities;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<List<NewsActivity>> getNewsActivities({
    required String userId,
  }) async {
    try {
      final newsActivityListResponse = await _activityClient.getNewsActivities(
        userId: userId,
      );
      final newsActivities = newsActivityListResponse.newsActivities
          .map(
            (newsActivityResponse) => NewsActivity.fromNewsActivityResponse(
              newsActivityResponse: newsActivityResponse,
            ),
          )
          .toList();
      return newsActivities;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
}
