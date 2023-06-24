import 'package:calender_repository/calender_repository.dart';

class CalendarEntryPreview {
  const CalendarEntryPreview({
    required this.day,
    required this.locations,
    required this.date,
    this.title,
  });

  final int day;
  final DateTime date;
  final String? title;
  final List<String> locations;

  String getTimeString(DateTime startTime) {
    final Duration difference = date.difference(startTime);

    final int days = difference.inDays;
    final int hours = difference.inHours % 24;
    final int minutes = difference.inMinutes % 60;

    String timeString = '';

    if (days > 0) {
      timeString += '$days Tag${days > 1 ? 'e' : ''} ';
    }

    if (hours > 0) {
      timeString += '$hours Stunde${hours > 1 ? 'n' : ''} ';
    }

    if (minutes > 0) {
      timeString += '$minutes Minute${minutes > 1 ? 'n' : ''} ';
    }

    return timeString.trim();
  }

  String getFormattedDate() {
    return '${date.day}.${date.month}.${date.year}';
  }

  String getFormattedTime() {
    return '${date.hour}:${date.minute <= 9 ? '0' : ''}${date.minute}';
  }

  static DateTime calculateDate(int week, int day, HourMinute start) {
    final now = DateTime.now();
    final today = now.weekday;
    int daysToAdd;
    if (week == 0 && day < today) {
      daysToAdd = (7 - today) + day;
    } else {
      daysToAdd = (7 * week) + (day - today);
    }
    return DateTime(
      now.year,
      now.month,
      now.day,
      start.hours,
      start.minutes,
    ).add(Duration(days: daysToAdd));
  }

  String getDay() {
    switch (day) {
      case 1:
        return 'Montag';
      case 2:
        return 'Dienstag';
      case 3:
        return 'Mittwoch';
      case 4:
        return 'Donnerstag';
      case 5:
        return 'Freitag';
      case 6:
        return 'Samstag';
      case 7:
        return 'Sonntag';
      default:
        return 'Unbekannt';
    }
  }
}
