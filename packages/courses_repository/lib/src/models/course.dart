import 'package:studip_api_client/studip_api_client.dart';

class Course {
  final String id;
  final String title;
  final String? subtitle;
  final String semesterId;

  const Course(
      {required this.id,
      required this.title,
      required this.subtitle,
      required this.semesterId});

  factory Course.fromCourseResponse(CourseResponse course) {
    return Course(
      id: course.id,
      title: course.title,
      subtitle: course.subtitle,
      semesterId: course.semesterId,
    );
  }
}
