import 'package:calender_repository/calender_repository.dart';
import 'package:studip_api_client/studip_api_client.dart';

class CalenderRepository {
  const CalenderRepository({
    required StudIPCalendarClient apiClient,
  }) : _apiClient = apiClient;
  final StudIPCalendarClient _apiClient;

  Future<CalendarWeekData> getCalendarSchedule({
    required String userId,
    required DateTime requestedDateTime,
  }) async {
    final schedule = await _apiClient.getSchedule(
      userId: userId,
      semesterStart: requestedDateTime,
    );
    return CalendarWeekData.fromScheduleResponse(
      scheduleResponse: schedule,
      requestedDateTime: requestedDateTime,
    );
  }
}
