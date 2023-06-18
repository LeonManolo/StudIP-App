import 'package:calender_repository/calender_repository.dart';
import 'package:studip_api_client/studip_api_client.dart';

class CalenderRepository {
  const CalenderRepository({
    required StudIPCalendarClient apiClient,
  }) : _apiClient = apiClient;
  final StudIPCalendarClient _apiClient;

  Future<CalendarWeekData> getCalenderSchedule({
    required String userId,
    DateTime? dateTime,
  }) async {
    try {
      final schedule =
          await _apiClient.getSchedule(userId: userId, semesterStart: dateTime);
      return CalendarWeekData.fromScheduleResponse(schedule);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
}
