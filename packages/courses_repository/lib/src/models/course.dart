import 'package:studip_api_client/studip_api_client.dart';

class Course {
  final String id;
  final CourseDetails courseDetails;
  final String semesterId;

  const Course(
      {required this.id,
      required this.courseDetails,
      required this.semesterId});

  factory Course.fromCourseResponse(CourseResponse response) {
    return Course(
      id: response.id,
      courseDetails:
          CourseDetails.fromCourseDetailsResponse(response.detailsResponse),
      semesterId: response.semesterId,
    );
  }
}

class CourseDetails {
  final String? courseNumber;
  final String title;
  final String? subtitle;
  final String? description;
  final String? location;

  CourseDetails({
    this.courseNumber,
    required this.title,
    this.subtitle,
    this.description,
    this.location,
  });

  factory CourseDetails.fromCourseDetailsResponse(
      CourseDetailsResponse response) {
    return CourseDetails(
      courseNumber: response.courseNumber,
      title: response.title,
      subtitle: response.subtitle,
      description: response.description,
      location: response.location,
    );
  }
}
