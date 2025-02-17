import 'package:calender_repository/src/models/models.dart';
import 'package:studip_api_client/studip_api_client.dart';

class CalendarWeekData {
  CalendarWeekData({required this.data});

  factory CalendarWeekData.fromScheduleResponse({
    required ScheduleListResponse scheduleResponse,
    required DateTime requestedDateTime,
    required bool shouldInclueCoursesAfterScheduleEntryStart,
  }) {
    final Map<Weekday, Map<String, List<CalendarEntryData>>> data = {};

    for (final scheduleData in scheduleResponse.scheduleEntries) {
      final weekdayNum = scheduleData.attributes.weekday;

      if (weekdayNum > 0 && weekdayNum < 8) {
        final timeframe = _toCalenderTimeframe(scheduleData.attributes);

        if (timeframe != null) {
          final startDate = DateTime(
            requestedDateTime.year,
            requestedDateTime.month,
            requestedDateTime.day,
            timeframe.start.hours,
            timeframe.start.minutes,
          ).toUtc();
          if (!_shouldIncludeScheduleEntry(
            scheduleEntryData: scheduleData,
            scheduleEntryStart: startDate,
            shouldInclueCoursesAfterScheduleEntryStart:
                shouldInclueCoursesAfterScheduleEntryStart,
          )) {
            continue;
          }

          final weekday = Weekday.fromIndex(weekdayNum - 1);
          final isCourseEvent =
              scheduleData.relationships.owner.data.type == 'courses';
          final entryData = CalendarEntryData(
            id: scheduleData.id,
            type: scheduleData.type,
            locations: scheduleData.attributes.locations ?? [],
            title: scheduleData.attributes.title,
            description: scheduleData.attributes.description,
            weekday: weekday,
            timeframe: timeframe,
            courseId:
                isCourseEvent ? scheduleData.relationships.owner.data.id : null,
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
    required ScheduleResponseItem scheduleEntryData,
    required DateTime scheduleEntryStart,
    required bool shouldInclueCoursesAfterScheduleEntryStart,
  }) {
    final recurrenceInfo = scheduleEntryData.attributes.recurrence;
    if (recurrenceInfo == null) return true;

    final firstOccurrence =
        DateTime.parse(recurrenceInfo.firstOccurrenceDateString);
    final lastOccurrence =
        DateTime.parse(recurrenceInfo.lastOccurrenceDateString);

    final List<DateTime> allOccurrences = [];
    final List<DateTime> excludedDates =
        recurrenceInfo.excludedDates?.map(DateTime.parse).toList() ?? [];

    var currentOccurrence = firstOccurrence;
    while (currentOccurrence.isBefore(lastOccurrence) ||
        currentOccurrence.isAtSameMomentAs(lastOccurrence)) {
      if (!excludedDates.contains(currentOccurrence)) {
        allOccurrences.add(currentOccurrence);
      }

      currentOccurrence =
          currentOccurrence.add(Duration(days: 7 * recurrenceInfo.interval));
    }

    if (shouldInclueCoursesAfterScheduleEntryStart) {
      // adjustedStartDate is set based on firstOccurence to the first appropriate date after scheduleEntryStart
      var adjustedStartDate = firstOccurrence;
      while (adjustedStartDate.isBefore(scheduleEntryStart)) {
        adjustedStartDate =
            adjustedStartDate.add(Duration(days: 7 * recurrenceInfo.interval));
      }
      return allOccurrences.contains(adjustedStartDate);
    } else {
      return allOccurrences.contains(scheduleEntryStart);
    }
  }

  static CalendarTimeframe? _toCalenderTimeframe(
    ScheduleResponseItemAttributes attributes,
  ) {
    final start = attributes.start.split(':');
    final end = attributes.end.split(':');

    if (start.length == 2 && end.length == 2) {
      final startHours = num.tryParse(start[0])?.toInt();
      final startMinutes = num.tryParse(start[1])?.toInt();
      final endHours = num.tryParse(end[0])?.toInt();
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
