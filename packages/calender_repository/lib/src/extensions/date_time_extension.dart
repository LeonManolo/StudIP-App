import 'package:calender_repository/calender_repository.dart';

extension DateTimeExtension on DateTime {
  HourMinute get hourMinute {
    return HourMinute(hours: hour, minutes: minute);
  }

  bool isSameDayAs(DateTime other) {
    return other.year == year && other.month == month && other.day == day;
  }
}
