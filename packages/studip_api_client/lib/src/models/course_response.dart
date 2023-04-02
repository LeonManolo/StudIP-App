class CourseResponse {
  final List<Course> courses;

  const CourseResponse({required this.courses});

  factory CourseResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> courses = json["data"];

    return CourseResponse(courses: courses.map((j) => Course.fromJson(j)).toList());
  }
}

class Course {
  final String id;
  final String title;
  final String? subtitle;

  const Course({required this.id, required this.title, required this.subtitle});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
        id: json["id"],
        title: json["attributes"]["title"],
        subtitle: json["attributes"]["subtitle"]);
  }
}
