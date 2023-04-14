import 'package:calender_repository/calender_repository.dart';

class CalendarEntryData {
  final String type;
  final String id;
  final String? title;
  final String? description;
  final Weekdays weekday;
  final List<String> locations;
  final CalendarTimeframe timeframe;

  const CalendarEntryData({
    required this.id,
    required this.type,
    required this.weekday,
    required this.timeframe,
    this.title,
    this.description,
    this.locations = const [],
  });
}
