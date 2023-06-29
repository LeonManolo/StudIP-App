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
      final entry1 = CalendarPreviewModel(
        day: 1,
        entryStartDate: DateTime.now(),
        locations: [],
      );
      final entry2 = CalendarPreviewModel(
        day: 2,
        entryStartDate: DateTime.now(),
        locations: [],
      );
      final entry3 = CalendarPreviewModel(
        day: 3,
        entryStartDate: DateTime.now(),
        locations: [],
      );
      final entry4 = CalendarPreviewModel(
        day: 4,
        entryStartDate: DateTime.now(),
        locations: [],
      );
      final entry5 = CalendarPreviewModel(
        day: 5,
        entryStartDate: DateTime.now(),
        locations: [],
      );
      final entry6 = CalendarPreviewModel(
        day: 6,
        entryStartDate: DateTime.now(),
        locations: [],
      );
      final entry7 = CalendarPreviewModel(
        day: 7,
        entryStartDate: DateTime.now(),
        locations: [],
      );

      expect(entry1.getDay(), 'Montag');
      expect(entry2.getDay(), 'Dienstag');
      expect(entry3.getDay(), 'Mittwoch');
      expect(entry4.getDay(), 'Donnerstag');
      expect(entry5.getDay(), 'Freitag');
      expect(entry6.getDay(), 'Samstag');
      expect(entry7.getDay(), 'Sonntag');
    });

    test('Returns "Unbekannt" for unknown day index', () {
      final entry = CalendarPreviewModel(
        day: 8,
        entryStartDate: DateTime.now(),
        locations: [],
      );

      expect(entry.getDay(), 'Unbekannt');
    });
  });
}
