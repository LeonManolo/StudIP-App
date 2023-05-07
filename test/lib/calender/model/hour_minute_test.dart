import 'package:calender_repository/src/models/hour_minute.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('constructor tests', () {
    test('Correct input', () {
      final hourMinute = HourMinute(hours: 8, minutes: 45);

      expect(hourMinute.hours, 8);
      expect(hourMinute.minutes, 45);
    });
    test('Hours > 23 then mod 24', () {
      final hourMinute = HourMinute(hours: 25, minutes: 45);

      expect(hourMinute.hours, 1);
      expect(hourMinute.minutes, 45);
    });
    test('Minutes > 59 then mod 60 and add minutes to ', () {
      final hourMinute = HourMinute(hours: 22, minutes: 60);
      expect(hourMinute.hours, 23);
      expect(hourMinute.minutes, 0);
    });

    test('Minutes > 59 and increases hours to more than 23', () {
      final hourMinute = HourMinute(hours: 22, minutes: 180);
      expect(hourMinute.hours, 1);
      expect(hourMinute.minutes, 0);
    });
  });

  group('minutesAwayFrom() Function tests', () {
    test('HourMinutes test with 0', () {
      final hourMinute = HourMinute(hours: 8, minutes: 45);
      final hourMinute2 = HourMinute(hours: 9, minutes: 0);

      expect(hourMinute.minutesAwayFrom(hourMinute2), 15);
    });
    test('HourMinutes test with multiple hours between', () {
      final hourMinute = HourMinute(hours: 8, minutes: 45);
      final hourMinute2 = HourMinute(hours: 11, minutes: 15);

      expect(hourMinute.minutesAwayFrom(hourMinute2), 150);
    });

    test('HourMinutes test with only minutes difference', () {
      final hourMinute = HourMinute(hours: 8, minutes: 45);
      final hourMinute2 = HourMinute(hours: 8, minutes: 49);

      expect(hourMinute.minutesAwayFrom(hourMinute2), 4);
    });

    test('HourMinutes test with negative difference', () {
      final hourMinute = HourMinute(hours: 8, minutes: 45);
      final hourMinute2 = HourMinute(hours: 7, minutes: 30);

      expect(hourMinute.minutesAwayFrom(hourMinute2), -75);
    });
  });
}
