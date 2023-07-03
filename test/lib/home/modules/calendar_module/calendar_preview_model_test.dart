import 'package:calender_repository/calender_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studipadawan/home/modules/calendar_module/model/calendar_preview_model.dart';

void main() {
  group('calculateDate', () {
    test('Returns correct DateTime when week is 0 and day is before today', () {
      final start = HourMinute(hours: 8, minutes: 30);
      final now = DateTime.now();
      final today = now.weekday;
      final entry = CalendarPreviewModel.calculateDate(0, today - 2, start);

      final expectedDate = DateTime(
        now.year,
        now.month,
        now.day,
        start.hours,
        start.minutes,
      ).add(Duration(days: (7 - today) + (today - 2)));

      expect(entry.year, expectedDate.year);
      expect(entry.month, expectedDate.month);
      expect(entry.day, expectedDate.day);
      expect(entry.hour, expectedDate.hour);
      expect(entry.minute, expectedDate.minute);
    });

    test('Returns correct DateTime when week is not 0', () {
      final start = HourMinute(hours: 14, minutes: 45);
      final now = DateTime.now();
      final today = now.weekday;
      final entry = CalendarPreviewModel.calculateDate(2, today + 3, start);

      final expectedDate = DateTime(
        now.year,
        now.month,
        now.day,
        start.hours,
        start.minutes,
      ).add(Duration(days: (7 * 2) + (today + 3 - today)));

      expect(entry.year, expectedDate.year);
      expect(entry.month, expectedDate.month);
      expect(entry.day, expectedDate.day);
      expect(entry.hour, expectedDate.hour);
      expect(entry.minute, expectedDate.minute);
    });
  });

  group('getDay', () {
    test('Returns the correct day string for each day index', () {
      final weekdayNames = [
        'Montag',
        'Dienstag',
        'Mittwoch',
        'Donnerstag',
        'Freitag',
        'Samstag',
        'Sonntag'
      ];

      for (int i = 0; i < weekdayNames.length; i++) {
        final entry = CalendarPreviewModel(
          entryStartDate: DateTime(2023, 06, 10, 15),
          calendarEntryData: CalendarEntryData(
            id: '1',
            type: '',
            weekday: Weekday.values[i],
            timeframe: CalendarTimeframe(
              start: HourMinute(hours: 10, minutes: 30),
              end: HourMinute(hours: 11, minutes: 30),
            ),
          ),
        );

        expect(entry.getDay(), weekdayNames[i]);
      }
    });
  });
}
