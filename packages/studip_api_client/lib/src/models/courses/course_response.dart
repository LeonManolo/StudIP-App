class CourseListResponse {
  final List<CourseResponse> courses;
  final int? offset;
  final int? limit;
  final int? total;

  const CourseListResponse(
      {required this.courses, this.offset, this.limit, this.total});

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
}

class CourseResponse {
  final String id;
  final String title;
  final String? subtitle;
  final String semesterId;

  const CourseResponse(
      {required this.id,
      required this.title,
      required this.subtitle,
      required this.semesterId});

  factory CourseResponse.fromJson(Map<String, dynamic> json) {
    return CourseResponse(
        id: json["id"],
        title: json["attributes"]["title"],
        subtitle: json["attributes"]["subtitle"],
        semesterId: json["relationships"]["start-semester"]["data"]["id"]);
  }
}
