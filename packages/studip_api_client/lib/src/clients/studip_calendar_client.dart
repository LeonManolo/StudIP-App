import 'package:studip_api_client/src/core/interfaces/interfaces.dart';
import 'package:studip_api_client/src/core/studip_api_core.dart';
import 'package:studip_api_client/src/extensions/extensions.dart';
import 'package:studip_api_client/src/models/models.dart';

abstract interface class StudIPCalendarClient {
  Future<ScheduleListResponse> getSchedule(
      {required String userId, DateTime? semesterStart,});
}

class StudIPCalendarClientImpl implements StudIPCalendarClient {

  StudIPCalendarClientImpl({StudIpHttpCore? core})
      : _core = core ?? StudIpAPICore.shared;
  final StudIpHttpCore _core;

  @override
  Future<ScheduleListResponse> getSchedule(
      {required String userId, DateTime? semesterStart,}) async {
    int semesterStartInMillisecondsSinceEpoch;
    if (semesterStart == null) {
      semesterStartInMillisecondsSinceEpoch = DateTime.now().secondsSinceEpoch;
    } else {
      semesterStartInMillisecondsSinceEpoch = semesterStart.secondsSinceEpoch;
    }

    final response = await _core.get(
        endpoint: 'users/$userId/schedule',
        queryParameters: {
          'filter[timestamp]': '$semesterStartInMillisecondsSinceEpoch'
        },);

    final body = response.json();
    response.throwIfInvalidHttpStatus(body: body);

    return ScheduleListResponse.fromJson(body);
  }
}
