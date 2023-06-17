import 'dart:async';
import 'dart:io';

import 'package:studip_api_client/src/core/interfaces/interfaces.dart';
import 'package:studip_api_client/src/core/studip_api_core.dart';
import 'package:studip_api_client/src/exceptions.dart';
import 'package:studip_api_client/src/extensions/extensions.dart';

import '../models/models.dart';

abstract interface class StudIPActivityClient {
  Future<FileActivityListResponse> getFileActivities({
    required String userId,
    required int limit,
  });
}

class StudIPActivityClientImpl implements StudIPActivityClient {
  final StudIpHttpCore _core;

  StudIPActivityClientImpl({StudIpHttpCore? core})
      : _core = core ?? StudIpAPICore.shared;
  @override
  Future<FileActivityListResponse> getFileActivities({
    required String userId,
    required int limit,
  }) async {
    final response = await _core.get(
        endpoint: "users/$userId/activitystream",
        queryParameters: {
          "filter[activity-type]": "documents",
          "page[limit]": limit.toString()
        });
    final body = response.json();
    if (response.statusCode != HttpStatus.ok) {
      throw StudIpApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }
    return FileActivityListResponse.fromJson(body);
  }
}
