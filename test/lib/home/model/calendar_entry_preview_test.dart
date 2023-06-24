import 'package:calender_repository/calender_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studipadawan/home/modules/calendar_module/model/calendar_entry_preview.dart';


void main() {
  group('getTimeString', () {
    test('Returns correct time string when days, hours, and minutes are present', () {
      final entry = CalendarEntryPreview(
        day: 2,
        date: DateTime.now().add(const Duration(days: 2, hours: 3, minutes: 15)),
        timeframe: 'xxx - xxx',
        locations: [],
      );
      final startTime = DateTime.now();

      final result = entry.getTimeString(startTime);

      expect(result, '2 Tage 3 Stunden 14 Minuten');
    });

    test('Returns correct time string when only hours and minutes are present', () {
      final entry = CalendarEntryPreview(
        day: 1,
        date: DateTime.now().add(const Duration(hours: 3, minutes: 45)),
        timeframe: 'xxx - xxx',
        locations: [],
      );
      final startTime = DateTime.now();

      final result = entry.getTimeString(startTime);

      expect(result, '3 Stunden 44 Minuten');
    });

    test('Returns correct time string when only minutes are present', () {
      final entry = CalendarEntryPreview(
        day: 5,
        date: DateTime.now().add(const Duration(minutes: 30)),
        timeframe: 'xxx - xxx',
        locations: [],
      );
      final startTime = DateTime.now();

      final result = entry.getTimeString(startTime);

      expect(result, '29 Minuten');
    });

    test('Returns empty string when no time difference', () {
      final entry = CalendarEntryPreview(
        day: 3,
        date: DateTime.now(),
        timeframe: 'xxx - xxx',
        locations: [],
      );
      final startTime = DateTime.now();

      final result = entry.getTimeString(startTime);

      expect(result, '');
    });
  });

  group('getFormattedDate', () {
    test('Returns formatted date string in "day.month.year" format', () {
      final entry = CalendarEntryPreview(
        day: 1,
        date: DateTime(2023, 6, 15),
        timeframe: 'xxx - xxx',
        locations: [],
      );

      final result = entry.getFormattedDate();

      expect(result, '15.6.2023');
    });
  });

  group('calculateDate', () {
    test('Returns correct DateTime when week is 0 and day is before today', () {
      final start = HourMinute(hours: 8, minutes: 30);
      final now = DateTime.now();
      final today = now.weekday;
      final entry = CalendarEntryPreview.calculateDate(0, today - 2, start);

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
      final entry = CalendarEntryPreview.calculateDate(2, today + 3, start);

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
      final entry1 = CalendarEntryPreview(day: 1, date: DateTime.now(), timeframe: 'xxx - xxx', locations: []);
      final entry2 = CalendarEntryPreview(day: 2, date: DateTime.now(), timeframe: 'xxx - xxx', locations: []);
      final entry3 = CalendarEntryPreview(day: 3, date: DateTime.now(), timeframe: 'xxx - xxx', locations: []);
      final entry4 = CalendarEntryPreview(day: 4, date: DateTime.now(), timeframe: 'xxx - xxx', locations: []);
      final entry5 = CalendarEntryPreview(day: 5, date: DateTime.now(), timeframe: 'xxx - xxx', locations: []);
      final entry6 = CalendarEntryPreview(day: 6, date: DateTime.now(), timeframe: 'xxx - xxx', locations: []);
      final entry7 = CalendarEntryPreview(day: 7, date: DateTime.now(), timeframe: 'xxx - xxx', locations: []);

      expect(entry1.getDay(), 'Montag');
      expect(entry2.getDay(), 'Dienstag');
      expect(entry3.getDay(), 'Mittwoch');
      expect(entry4.getDay(), 'Donnerstag');
      expect(entry5.getDay(), 'Freitag');
      expect(entry6.getDay(), 'Samstag');
      expect(entry7.getDay(), 'Sonntag');
    });

    test('Returns "Unbekannt" for unknown day index', () {
      final entry = CalendarEntryPreview(day: 8, date: DateTime.now(), timeframe: '', locations: []);

      expect(entry.getDay(), 'Unbekannt');
    });
  });
}
