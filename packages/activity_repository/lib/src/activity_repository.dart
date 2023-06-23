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
      final _ActivityListIncludedData includedData =
          _getIncludedData(activityListResponse: fileActivityListResponse);

      final List<FileActivity> fileActivities = fileActivityListResponse
          .activityResponseItems
          .map((fileAcitvityResponseItem) {
        final fileResponseItem = includedData.fileResponseItems.firstWhere(
          (fileResponseItem) =>
              fileResponseItem.id == fileAcitvityResponseItem.objectId,
        );

        final userResponseItem = includedData.userResponseItems.firstWhere(
          (userResponseItem) =>
              userResponseItem.id == fileAcitvityResponseItem.actorId,
        );

        final courseResponseItem = includedData.courseResponseItems.firstWhere(
          (courseResponseItem) =>
              courseResponseItem.id == fileAcitvityResponseItem.contextId,
        );

        return FileActivity.fromFileActivityResponse(
          activityResponseItem: fileAcitvityResponseItem,
          fileResponseItem: fileResponseItem,
          userResponseItem: userResponseItem,
          courseResponseItem: courseResponseItem,
        );
      }).toList();

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

      final _ActivityListIncludedData includedData =
          _getIncludedData(activityListResponse: newsActivityListResponse);

      final List<NewsActivity> newsActivities = newsActivityListResponse
          .activityResponseItems
          .map((newsAcitvityResponseItem) {
        final courseNewsResponseItem =
            includedData.courseNewsResponseItems.firstWhere(
          (newsResponseItem) =>
              newsResponseItem.id == newsAcitvityResponseItem.objectId,
        );

        final userResponseItem = includedData.userResponseItems.firstWhere(
          (userResponseItem) =>
              userResponseItem.id == newsAcitvityResponseItem.actorId,
        );

        final courseResponseItem = includedData.courseResponseItems.firstWhere(
          (courseResponseItem) =>
              courseResponseItem.id == newsAcitvityResponseItem.contextId,
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

  _ActivityListIncludedData _getIncludedData({
    required ActivityListResponse activityListResponse,
  }) {
    return activityListResponse.included.fold(_ActivityListIncludedData.empty(),
        (previousValue, element) {
      switch (element) {
        case final ActivityListResponseIncludedUser includedUser:
          return previousValue.copyWith(
            userResponseItems: previousValue.userResponseItems +
                [includedUser.userResponseItem],
          );

        case final ActivityListResponseIncludedNews includedNews:
          return previousValue.copyWith(
            courseNewsResponseItems: previousValue.courseNewsResponseItems +
                [includedNews.newsResponseItem],
          );

        case final ActivityListResponseIncludedCourse includedCourse:
          return previousValue.copyWith(
            courseResponseItems: previousValue.courseResponseItems +
                [includedCourse.courseResponseItem],
          );

        case final ActivityListResponseIncludedFile includedFile:
          return previousValue.copyWith(
            fileResponseItems: previousValue.fileResponseItems +
                [includedFile.fileResponseItem],
          );
      }
    });
  }
}

class _ActivityListIncludedData {
  _ActivityListIncludedData({
    required this.userResponseItems,
    required this.courseNewsResponseItems,
    required this.courseResponseItems,
    required this.fileResponseItems,
  });

  factory _ActivityListIncludedData.empty() => _ActivityListIncludedData(
        courseNewsResponseItems: [],
        userResponseItems: [],
        courseResponseItems: [],
        fileResponseItems: [],
      );

  final List<UserResponseItem> userResponseItems;
  final List<CourseNewsResponseItem> courseNewsResponseItems;
  final List<CourseResponseItem> courseResponseItems;
  final List<FileResponseItem> fileResponseItems;

  _ActivityListIncludedData copyWith({
    List<UserResponseItem>? userResponseItems,
    List<CourseNewsResponseItem>? courseNewsResponseItems,
    List<CourseResponseItem>? courseResponseItems,
    List<FileResponseItem>? fileResponseItems,
  }) {
    return _ActivityListIncludedData(
      userResponseItems: userResponseItems ?? this.userResponseItems,
      courseNewsResponseItems:
          courseNewsResponseItems ?? this.courseNewsResponseItems,
      courseResponseItems: courseResponseItems ?? this.courseResponseItems,
      fileResponseItems: fileResponseItems ?? this.fileResponseItems,
    );
  }
}
