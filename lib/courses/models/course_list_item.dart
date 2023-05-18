import 'package:courses_repository/courses_repository.dart';

sealed class CourseListItem {}

class CourseListCourseItem extends CourseListItem {
  CourseListCourseItem({required this.course});

  final Course course;
}

class CourseListSemesterItem extends CourseListItem {
  CourseListSemesterItem({required this.semester});

  final Semester semester;
}
