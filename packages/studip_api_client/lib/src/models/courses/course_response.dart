class CourseListResponse {
  final List<CourseResponse> courses;

  const CourseListResponse({required this.courses});

  factory CourseListResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> courses = json["data"];

    return CourseListResponse(
        courses: courses.map((j) => CourseResponse.fromJson(j)).toList());
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
