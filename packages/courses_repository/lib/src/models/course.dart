import 'package:studip_api_client/studip_api_client.dart';

class Course {
  const Course({
    required this.id,
    required this.courseDetails,
    required this.semesterId,
  });

  factory Course.fromCourseResponse(CourseResponseItem response) {
    return Course(
      id: response.id,
      courseDetails:
          CourseDetails.fromCourseDetailsResponse(response.attributes),
      semesterId: response.startSemesterId,
    );
  }
  final String id;
  final CourseDetails courseDetails;
  final String semesterId;
}

class CourseDetails {
  CourseDetails({
    this.courseNumber,
    required this.title,
    this.subtitle,
    this.description,
    this.location,
  });

  factory CourseDetails.fromCourseDetailsResponse(
    CourseResponseItemAttributes response,
  ) {
    return CourseDetails(
      courseNumber: response.courseNumber,
      title: response.title,
      subtitle: response.subtitle,
      description: response.description,
      location: response.location,
    );
  }
  final String? courseNumber;
  final String title;
  final String? subtitle;
  final String? description;
  final String? location;
}
