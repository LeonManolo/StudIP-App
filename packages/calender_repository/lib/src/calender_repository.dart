import 'package:calender_repository/calender_repository.dart';
import 'package:studip_api_client/studip_api_client.dart';

class CalenderRepository {
  final StudIpApiClient _apiClient;

  const CalenderRepository({
    required StudIpApiClient apiClient,
  }) : _apiClient = apiClient;

  Future<CalendarWeekData> getCalenderSchedule(
      {required String userId, DateTime? dateTime}) async {
    final schedule =
        await _apiClient.getSchedule(userId: userId, semesterStart: dateTime);
    return CalendarWeekData.fromScheduleResponse(schedule);
  }

}
