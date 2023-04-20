import 'package:calender_repository/calender_repository.dart';
import 'package:test/test.dart';

void main() {
  group("containsHourMinute", () {
    test("should contain HourMinute", () {
      final timeframe = CalendarTimeframe(
        start: HourMinute(hours: 8, minutes: 15),
        end: HourMinute(hours: 10, minutes: 0),
      );

      expect(
          timeframe.containsHourMinute(HourMinute(hours: 9, minutes: 0)), true);
      expect(
          timeframe.containsHourMinute(HourMinute(hours: 8, minutes: 14)), false);
      expect(
          timeframe.containsHourMinute(HourMinute(hours: 8, minutes: 15)), true);
      expect(
          timeframe.containsHourMinute(HourMinute(hours: 10, minutes: 0)), true);
      expect(
          timeframe.containsHourMinute(HourMinute(hours: 10, minutes: 1)), false);
    });
  });
}
