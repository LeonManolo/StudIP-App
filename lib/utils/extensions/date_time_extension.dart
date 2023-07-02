import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String getFormattedGermanTimeSpanBetweenDates(DateTime other) {
    if (year == other.year && month == other.month && day == other.day) {
      return "${DateFormat("dd.MM.yyyy").format(this)} (${DateFormat("HH:mm").format(this)} - ${DateFormat("HH:mm").format(other)})";
    }

    return "${DateFormat("dd.MM.yyyy (HH:mm)").format(this)} - ${DateFormat("dd.MM.yyyy (HH:mm)").format(other)}";
  }
}
