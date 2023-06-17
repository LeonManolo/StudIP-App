import 'dart:io';

import 'package:logger/logger.dart';
import 'package:studip_api_client/src/core/interfaces/interfaces.dart';
import 'package:studip_api_client/src/core/studip_api_core.dart';
import 'package:studip_api_client/src/extensions/extensions.dart';
import 'package:studip_api_client/src/exceptions.dart';
import 'package:studip_api_client/src/models/models.dart';

abstract interface class StudIPCalendarClient {
  Future<ScheduleResponse> getSchedule(
      {required String userId, DateTime? semesterStart});
}

class StudIPCalendarClientImpl implements StudIPCalendarClient {
  final StudIpHttpCore _core;

  StudIPCalendarClientImpl({StudIpHttpCore? core})
      : _core = core ?? StudIpAPICore.shared;

  @override
  Future<ScheduleResponse> getSchedule(
      {required String userId, DateTime? semesterStart}) async {
    int semesterStartInMillisecondsSinceEpoch;
    if (semesterStart == null) {
      semesterStartInMillisecondsSinceEpoch = DateTime.now().secondsSinceEpoch;
    } else {
      semesterStartInMillisecondsSinceEpoch = semesterStart.secondsSinceEpoch;
    }

    final response = await _core.get(
        endpoint: "users/$userId/schedule",
        queryParameters: {
          "filter[timestamp]": "$semesterStartInMillisecondsSinceEpoch"
        });

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      final failure = StudIpApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
      Logger().e("Unexpected Response status code", failure);
      throw failure;
    }
    return ScheduleResponse.fromJson(body);
  }
}
