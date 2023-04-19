import 'package:studip_api_client/src/models/models.dart' as APIModels;

class CourseNews {
  final String id;
  final String title;
  final String content;
  final DateTime publicationStart;
  final DateTime publicationEnd;

  CourseNews({
    required this.id,
    required this.title,
    required this.content,
    required this.publicationStart,
    required this.publicationEnd,
  });

  factory CourseNews.fromCourseNewsResponse(
      {required APIModels.CourseNewsResponse courseNewsResponse}) {
    return CourseNews(
      id: courseNewsResponse.id,
      title: courseNewsResponse.title,
      content: courseNewsResponse.content,
      publicationStart: DateTime.parse(courseNewsResponse.publicationStart),
      publicationEnd: DateTime.parse(courseNewsResponse.publicationEnd),
    );
  }
}
