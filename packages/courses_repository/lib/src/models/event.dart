import 'package:intl/intl.dart';
import 'package:studip_api_client/studip_api_client.dart' as studip_api_client;

class StudIPCourseEventItem {
  StudIPCourseEventItem({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.categories,
    this.location,
  });

  factory StudIPCourseEventItem.fromCourseEventResponseItem({
    required studip_api_client.CourseEventResponseItem item,
  }) {
    return StudIPCourseEventItem(
      id: item.id,
      title: item.attributes.title,
      description: item.attributes.description,
      startDate: DateTime.parse(item.attributes.start).toLocal(),
      endDate: DateTime.parse(item.attributes.end).toLocal(),
      categories: item.attributes.categories,
      location: item.attributes.location,
    );
  }

  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> categories;
  final String? location;

  String get getEventTimeSpan {
    if (startDate.year == endDate.year &&
        startDate.month == endDate.month &&
        startDate.day == endDate.day) {
      return "${DateFormat("dd.MM.yyyy").format(startDate)} (${DateFormat("HH:mm").format(startDate)} - ${DateFormat("HH:mm").format(endDate)})";
    }

    return "${DateFormat("dd.MM.yyyy (HH:mm)").format(startDate)} - ${DateFormat("dd.MM.yyyy (HH:mm)").format(endDate)}";
  }
}
