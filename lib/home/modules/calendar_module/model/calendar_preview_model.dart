import 'package:calender_repository/calender_repository.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:studipadawan/home/models/preview_model.dart';
import 'package:studipadawan/home/modules/extensions/date_time_extensions.dart';

class CalendarPreviewModel implements PreviewModel {
  const CalendarPreviewModel({
    required this.entryStartDate,
    required this.calendarEntryData,
  });

  final CalendarEntryData calendarEntryData;
  final DateTime entryStartDate;
  int get day => calendarEntryData.weekday.index + 1;

  @override
  IconData get iconData => EvaIcons.calendarOutline;

  @override
  String get subtitle =>
      'In ${entryStartDate.germanTimeCountdown(countdownStart: DateTime.now())}'
      '\n${getDay()}, ${entryStartDate.formattedDateTime()} Uhr'
      '${calendarEntryData.locations.isNotEmpty ? '\nOrt: ${calendarEntryData.locations.join(', ')}' : ''}';

  @override
  String get title => calendarEntryData.title ?? 'Termin ohne Titel';

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
