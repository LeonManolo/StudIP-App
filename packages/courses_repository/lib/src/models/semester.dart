import 'package:courses_repository/src/models/course.dart';
import 'package:intl/intl.dart';
import 'package:studip_api_client/studip_api_client.dart';

class Semester {
  Semester({
    required this.id,
    required this.title,
    this.description,
    required this.start,
    required this.end,
    required this.startOfLectures,
    required this.endOfLectures,
    required this.courses,
  });

  factory Semester.fromSemesterResponse({
    required SemesterResponseItem semesterResponseItem,
    required List<Course> courses,
  }) {
    final SemesterResponseItemAttributes attributes =
        semesterResponseItem.attributes;
    return Semester(
      id: semesterResponseItem.id,
      title: attributes.title,
      start: DateTime.parse(attributes.start).toLocal(),
      end: DateTime.parse(attributes.end).toLocal(),
      startOfLectures: DateTime.parse(attributes.startOfLectures).toLocal(),
      endOfLectures: DateTime.parse(attributes.endOfLectures).toLocal(),
      courses: courses,
    );
  }
  final String id;
  final String title;
  final String? description;
  final DateTime start;
  final DateTime end;
  final DateTime startOfLectures;
  final DateTime endOfLectures;
  final List<Course> courses;

  String get semesterTimeSpan {
    return "${DateFormat("dd.MM.yyyy").format(start)} - ${DateFormat("dd.MM.yyyy").format(end)}";
  }

  String get lecturesTimeSpan {
    return "${DateFormat("dd.MM.yyyy").format(startOfLectures)} - ${DateFormat("dd.MM.yyyy").format(endOfLectures)}";
  }

  bool isCurrentSemester({required DateTime currentDateTime}) {
    return currentDateTime.isAfter(start) && currentDateTime.isBefore(end);
  }
}
