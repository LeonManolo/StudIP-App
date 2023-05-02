import 'package:studip_api_client/studip_api_client.dart' as studip_api_client;
import 'package:intl/intl.dart';

class StudIPCourseEvent {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> categories;
  final String? location;

  StudIPCourseEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.categories,
    this.location,
  });

  factory StudIPCourseEvent.fromCourseEventResponse(
      {required studip_api_client.CourseEventResponse courseEventResponse}) {
    return StudIPCourseEvent(
        id: courseEventResponse.id,
        title: courseEventResponse.title,
        description: courseEventResponse.description,
        startDate: DateTime.parse(courseEventResponse.start).toLocal(),
        endDate: DateTime.parse(courseEventResponse.end).toLocal(),
        categories: courseEventResponse.categories);
  }

  String get getEventTimeSpan {
    if (startDate.year == endDate.year &&
        startDate.month == endDate.month &&
        startDate.day == endDate.day) {
      return "${DateFormat("dd.MM.yyyy").format(startDate)} (${DateFormat("HH:mm").format(startDate)} - ${DateFormat("HH:mm").format(endDate)})";
    }

    return "${DateFormat("dd.MM.yyyy (HH:mm)").format(startDate)} - ${DateFormat("dd.MM.yyyy (HH:mm)").format(endDate)}";
  }
}
