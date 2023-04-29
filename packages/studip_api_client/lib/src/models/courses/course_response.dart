import 'package:studip_api_client/studip_api_client.dart';

class CourseListResponse implements ItemListResponse<CourseResponse> {
  final List<CourseResponse> courses;
  @override
  final int offset;
  @override
  final int limit;
  @override
  final int total;

  const CourseListResponse({
    required this.courses,
    required this.offset,
    required this.limit,
    required this.total,
  });

  factory CourseListResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> courses = json["data"];
    Map<String, dynamic> pageInfo = json["meta"]["page"];

    return CourseListResponse(
        courses: courses
            .map((rawCourseResponse) =>
                CourseResponse.fromJson(rawCourseResponse))
            .toList(),
        offset: pageInfo["offset"],
        limit: pageInfo["limit"],
        total: pageInfo["total"]);
  }

  @override
  List<CourseResponse> get items => courses;
}

class CourseResponse {
  final String id;
  final CourseDetailsResponse detailsResponse;
  final String semesterId;

  const CourseResponse(
      {required this.id,
      required this.detailsResponse,
      required this.semesterId});

  factory CourseResponse.fromJson(Map<String, dynamic> json) {
    return CourseResponse(
        id: json["id"],
        detailsResponse: CourseDetailsResponse.fromJson(json["attributes"]),
        semesterId: json["relationships"]["start-semester"]["data"]["id"]);
  }
}

class CourseDetailsResponse {
  final String? courseNumber;
  final String title;
  final String? subtitle;
  final String? description;
  final String? location;

  CourseDetailsResponse({
    this.courseNumber,
    required this.title,
    this.subtitle,
    this.description,
    this.location,
  });

  factory CourseDetailsResponse.fromJson(Map<String, dynamic> json) {
    return CourseDetailsResponse(
      courseNumber: json["course-number"],
      title: json["title"],
      subtitle: json["subtitle"],
      description: json["description"],
      location: json["location"],
    );
  }
}
