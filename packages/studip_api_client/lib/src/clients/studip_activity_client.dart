import 'dart:async';

import 'package:studip_api_client/src/core/interfaces/interfaces.dart';
import 'package:studip_api_client/src/core/studip_api_core.dart';
import 'package:studip_api_client/studip_api_client.dart';

enum ActivityType {
  news('news'),
  file('documents');

  const ActivityType(this.type);
  final String type;
}

abstract interface class StudIPActivityClient {
  Future<FileActivityListResponse> getFileActivities({
    required String userId,
    required int limit,
  });

  Future<NewsActivityListResponse> getNewsActivities({
    required String userId,
    required int limit,
  });
}

class StudIPActivityClientImpl implements StudIPActivityClient {
  final StudIpHttpCore _core;

  StudIPActivityClientImpl({StudIpHttpCore? core})
      : _core = core ?? StudIpAPICore.shared;

  @override
  getFileActivities({
    required String userId,
    required int limit,
  }) async {
    final response = await _getActivities(
      userId: userId,
      activityType: ActivityType.file,
      limit: limit,
    );
    return FileActivityListResponse.fromJson(response);
  }

  @override
  getNewsActivities({
    required String userId,
    required int limit,
  }) async {
    final response = await _getActivities(
      userId: userId,
      activityType: ActivityType.news,
      limit: limit,
    );
    return NewsActivityListResponse.fromJson(response);
  }

  Future<Map<String, dynamic>> _getActivities({
    required String userId,
    required ActivityType activityType,
    required int limit,
  }) async {
    final response = await _core.get(
        endpoint: "users/$userId/activitystream",
        queryParameters: {
          "filter[activity-type]": activityType.type,
          "page[limit]": limit.toString()
        });
    final body = response.json();
    response.throwIfInvalidHttpStatus(body: body);
    return body;
  }
}
