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
      final _NewsActivityListIncludedData includedData =
          newsActivityListResponse.included.fold(
              _NewsActivityListIncludedData.empty(), (previousValue, element) {
        switch (element) {
          case final NewsActivityListResponseIncludedUser includedUser:
            return previousValue.copyWith(
              userResponseItems: previousValue.userResponseItems +
                  [includedUser.userResponseItem],
            );

          case final NewsActivityListResponseIncludedNews includedNews:
            return previousValue.copyWith(
              courseNewsResponseItems: previousValue.courseNewsResponseItems +
                  [includedNews.courseNewsResponseItem],
            );

          case final NewsActivityListResponseIncludedCourse includedCourse:
            return previousValue.copyWith(
              courseResponseItems: previousValue.courseResponseItems +
                  [includedCourse.courseResponseItem],
            );
        }
      });

      final List<NewsActivity> newsActivities = newsActivityListResponse
          .newsActivityResponseItems
          .map((newsAcitvityResponseItem) {
        final courseNewsResponseItem =
            includedData.courseNewsResponseItems.firstWhere(
          (newsResponseItem) =>
              newsResponseItem.id == newsAcitvityResponseItem.newsId,
        );

        final userResponseItem = includedData.userResponseItems.firstWhere(
          (userResponseItem) =>
              userResponseItem.id == newsAcitvityResponseItem.userId,
        );

        final courseResponseItem = includedData.courseResponseItems.firstWhere(
          (courseResponseItem) =>
              courseResponseItem.id == newsAcitvityResponseItem.courseId,
        );

        return NewsActivity.fromNewsActivityResponse(
          newsResponseItem: courseNewsResponseItem,
          userResponseItem: userResponseItem,
          courseResponseItem: courseResponseItem,
        );
      }).toList();

      return newsActivities;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
}

class _NewsActivityListIncludedData {
  _NewsActivityListIncludedData({
    required this.userResponseItems,
    required this.courseNewsResponseItems,
    required this.courseResponseItems,
  });

  factory _NewsActivityListIncludedData.empty() =>
      _NewsActivityListIncludedData(
        courseNewsResponseItems: [],
        userResponseItems: [],
        courseResponseItems: [],
      );

  final List<UserResponseItem> userResponseItems;
  final List<CourseNewsResponseItem> courseNewsResponseItems;
  final List<CourseResponseItem> courseResponseItems;

  _NewsActivityListIncludedData copyWith({
    List<UserResponseItem>? userResponseItems,
    List<CourseNewsResponseItem>? courseNewsResponseItems,
    List<CourseResponseItem>? courseResponseItems,
  }) {
    return _NewsActivityListIncludedData(
      userResponseItems: userResponseItems ?? this.userResponseItems,
      courseNewsResponseItems:
          courseNewsResponseItems ?? this.courseNewsResponseItems,
      courseResponseItems: courseResponseItems ?? this.courseResponseItems,
    );
  }
}
