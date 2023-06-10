import 'package:calender_repository/src/models/models.dart';
import 'package:studip_api_client/studip_api_client.dart';

class CalendarWeekData {
  CalendarWeekData({required this.data});

  factory CalendarWeekData.fromScheduleResponse({
    required ScheduleResponse scheduleResponse,
    required DateTime currentDateTime,
  }) {
    final Map<Weekday, Map<String, List<CalendarEntryData>>> data = {};

    for (final scheduleData in scheduleResponse.scheduleEntries) {
      final weekdayNum = scheduleData.attributes?.weekday;

      if (weekdayNum != null && weekdayNum > 0 && weekdayNum < 8) {
        final timeframe = _toCalenderTimeframe(scheduleData.attributes);

        if (timeframe != null) {
          final startDate = DateTime(
            currentDateTime.year,
            currentDateTime.month,
            currentDateTime.day,
            timeframe.start.hours,
            timeframe.start.minutes,
          ).toUtc();
          if (!_shouldIncludeScheduleEntry(
            scheduleEntryData: scheduleData,
            scheduleEntryStart: startDate,
          )) {
            continue;
          }

          final weekday = Weekday.fromIndex(weekdayNum - 1);
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
            data[weekday] = {
              timeframe.combinedKey(): [entryData]
            };
          } else {
            // Check if the list for this timeframe key exists. If not, create it.
            data[weekday]![timeframe.combinedKey()] ??= [];

            data[weekday]![timeframe.combinedKey()]!
                .insertAndMaintainSortOrder(entryData);
          }
        }
      }
    }
    return CalendarWeekData(data: data);
  }
  final Map<Weekday, Map<String, List<CalendarEntryData>>> data;

  static bool _shouldIncludeScheduleEntry({
    required ScheduleEntryData scheduleEntryData,
    required DateTime scheduleEntryStart,
  }) {
    final recurrenceInfo = scheduleEntryData.attributes?.recurrence;
    if (recurrenceInfo == null) return true;

    final firstOccurrence =
        DateTime.parse(recurrenceInfo.firstOccurrenceDateString);
    final lastOccurrence =
        DateTime.parse(recurrenceInfo.lastOccurrenceDateString);

    final List<DateTime> allOccurrences = [];
    final List<DateTime> excludedDates =
        recurrenceInfo.excludedDates.map(DateTime.parse).toList();

    var currentOccurrence = firstOccurrence;
    while (currentOccurrence.isBefore(lastOccurrence) ||
        currentOccurrence.isAtSameMomentAs(lastOccurrence)) {
      if (!excludedDates.contains(currentOccurrence)) {
        allOccurrences.add(currentOccurrence);
      }

      currentOccurrence =
          currentOccurrence.add(Duration(days: 7 * recurrenceInfo.interval));
    }

    return allOccurrences.contains(scheduleEntryStart);
  }

  static CalendarTimeframe? _toCalenderTimeframe(Attributes? attributes) {
    final start = attributes?.start?.split(':');
    final end = attributes?.end?.split(':');

    if (start?.length == 2 && end?.length == 2) {
      final startHours = num.tryParse(start![0])?.toInt();
      final startMinutes = num.tryParse(start[1])?.toInt();
      final endHours = num.tryParse(end![0])?.toInt();
      final endMinutes = num.tryParse(end[1])?.toInt();

      if (startHours != null &&
          startMinutes != null &&
          endHours != null &&
          endMinutes != null) {
        return CalendarTimeframe(
          start: HourMinute(hours: startHours, minutes: startMinutes),
          end: HourMinute(hours: endHours, minutes: endMinutes),
        );
      }
    }

    return null;
  }
}
