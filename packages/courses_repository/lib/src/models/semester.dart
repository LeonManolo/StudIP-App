import 'course.dart';
import 'package:studip_api_client/src/models/models.dart' as APIModels;

class Semester {
  final String id;
  final String title;
  final String? description;
  final DateTime start;
  final DateTime end;
  final DateTime startOfLectures;
  final DateTime endOfLectures;
  final List<Course> courses;

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

  factory Semester.fromSemesterResponse(
      {required APIModels.SemesterResponse semesterResponse,
      required List<Course> courses}) {
    return Semester(
      id: semesterResponse.id,
      title: semesterResponse.title,
      start: DateTime.parse(semesterResponse.start),
      end: DateTime.parse(semesterResponse.end),
      startOfLectures: DateTime.parse(semesterResponse.startOfLectures),
      endOfLectures: DateTime.parse(semesterResponse.endOfLectures),
      courses: courses,
    );
  }
}
