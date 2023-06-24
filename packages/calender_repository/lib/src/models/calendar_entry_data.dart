import 'package:calender_repository/calender_repository.dart';

class CalendarEntryData {
  const CalendarEntryData({
    required this.id,
    required this.type,
    required this.weekday,
    required this.timeframe,
    this.title,
    this.description,
    this.locations = const [],
  });
  final String type;
  final String id;
  final String? title;
  final String? description;
  final Weekday weekday;
  final List<String> locations;
  final CalendarTimeframe timeframe;
}

extension CalendarEntryDataList on List<CalendarEntryData> {
  /// Inserts a new [CalendarEntryData] instance and maintains sort order based on [timeframe] attribute.
  /// [weekday] is ignored for determining the correct position of the new element.
  void insertAndMaintainSortOrder(CalendarEntryData newEntryData) {
    for (int i = 0; i < length; i++) {
      if (elementAt(i).timeframe.start.isAfter(newEntryData.timeframe.start)) {
        insert(i, newEntryData);
        return;
      }
    }

    add(newEntryData); // fallback if list is empty or no smaller timeframe present
  }
}
