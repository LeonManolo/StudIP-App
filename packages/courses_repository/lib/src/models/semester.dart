import 'course.dart';

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
}
