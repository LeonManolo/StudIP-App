import 'course.dart';
import 'package:intl/intl.dart';
import 'package:courses_repository/src/models/models.dart' as RepositoryModels;

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
    required RepositoryModels.Semester repositorySemester,
    required this.courses,
  })  : id = repositorySemester.id,
        title = repositorySemester.title,
        description = repositorySemester.description,
        start = repositorySemester.start,
        end = repositorySemester.end,
        startOfLectures = repositorySemester.startOfLectures,
        endOfLectures = repositorySemester.endOfLectures;

  String get semesterTimeSpan {
    return "${DateFormat("dd.MM.yyyy").format(start)} - ${DateFormat("dd.MM.yyyy").format(end)}";
  }

  String get lecturesTimeSpan {
    return "${DateFormat("dd.MM.yyyy").format(startOfLectures)} - ${DateFormat("dd.MM.yyyy").format(endOfLectures)}";
  }
}
