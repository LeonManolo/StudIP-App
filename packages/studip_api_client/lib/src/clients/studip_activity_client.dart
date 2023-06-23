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
  Future<ActivityListResponse> getFileActivities({
    required String userId,
    required int limit,
  });

  Future<ActivityListResponse> getNewsActivities({
    required String userId,
    int? limit,
  });
}

class StudIPActivityClientImpl implements StudIPActivityClient {
  final StudIpHttpCore _core;

  StudIPActivityClientImpl({StudIpHttpCore? core})
      : _core = core ?? StudIpAPICore.shared;

  @override
  Future<ActivityListResponse> getFileActivities({
    required String userId,
    required int limit,
  }) async {
    final response = await _getActivities(
      userId: userId,
      activityType: ActivityType.file,
      limit: limit,
    );

    return ActivityListResponse.fromJson(response);
  }

  @override
  Future<ActivityListResponse> getNewsActivities({
    required String userId,
    int? limit,
  }) async {
    final response = await _getActivities(
      userId: userId,
      activityType: ActivityType.news,
      limit: limit,
    );
    return ActivityListResponse.fromJson(response);
  }

  Future<Map<String, dynamic>> _getActivities({
    required String userId,
    required ActivityType activityType,
    required int? limit,
  }) async {
    final queryParameters = {
      "filter[activity-type]": activityType.type,
      "include": "object,actor,context",
    };
    if (limit != null) {
      queryParameters["page[limit]"] = limit.toString();
    }

    final response = await _core.get(
        endpoint: "users/$userId/activitystream",
        queryParameters: queryParameters);
    final body = response.json();
    response.throwIfInvalidHttpStatus(body: body);
    return body;
  }
}
