import 'package:calender_repository/src/models/models.dart';
import 'package:studip_api_client/studip_api_client.dart';

class CalendarWeekData {

  CalendarWeekData({required this.data});

  factory CalendarWeekData.fromScheduleResponse(
      ScheduleResponse scheduleResponse,) {
    final Map<Weekdays, Map<String, List<CalendarEntryData>>> data = {};
    for (final scheduleData in scheduleResponse.data) {
      final weekdayNum = scheduleData.attributes?.weekday;
      if (weekdayNum != null && weekdayNum > 0 && weekdayNum < 8) {
        final timeframe = _toCalenderTimeframe(scheduleData.attributes);
        if (timeframe != null) {
          final weekday = Weekdays.indexToWeekday(weekdayNum - 1);
          final entryData = CalendarEntryData(
            id: scheduleData.id,
            type: scheduleData.type,
            locations: scheduleData.attributes?.locations ?? [],
            title: scheduleData.attributes?.title,
            description: scheduleData.attributes?.description,
            weekday: weekday,
            timeframe: timeframe,
          );
          if (data[weekday] == null) {
            data[weekday] = {timeframe.combinedKey(): [entryData]};
          } else {
            data[weekday]![timeframe.combinedKey()]?.add(entryData);
          }
        }
      }
    }
    return CalendarWeekData(data: data);
  }
  final Map<Weekdays, Map<String, List<CalendarEntryData>>> data;

  static CalendarTimeframe? _toCalenderTimeframe(Attributes? attributes) {
    final start = attributes?.start?.split(':');
    final end = attributes?.end?.split(':');
    if (start?.length == 2 && end?.length == 2) {
      final startHours = num.tryParse(start![0])?.toInt();
      final startMinutes = num.tryParse(start[1])?.toInt();
      final endHours = num.tryParse(end![0])?.toInt();
      final endMinutes = num.tryParse(end[1])?.toInt();
      if (startHours != null && startMinutes != null) {
        if (endHours != null && endMinutes != null) {
          return CalendarTimeframe(
            start: HourMinute(hours: startHours, minutes: startMinutes),
            end: HourMinute(hours: endHours, minutes: endMinutes),
          );
        }
      }
    }
    return null;
  }
}
