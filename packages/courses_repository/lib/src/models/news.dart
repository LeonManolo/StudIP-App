import 'package:studip_api_client/studip_api_client.dart' as studip_api_client;

class CourseNews {

  CourseNews({
    required this.id,
    required this.title,
    required this.content,
    required this.publicationStart,
    required this.publicationEnd,
  });

  factory CourseNews.fromCourseNewsResponse(
      {required studip_api_client.CourseNewsResponse courseNewsResponse,}) {
    return CourseNews(
      id: courseNewsResponse.id,
      title: courseNewsResponse.title,
      content: courseNewsResponse.content,
      publicationStart:
          DateTime.parse(courseNewsResponse.publicationStart).toLocal(),
      publicationEnd:
          DateTime.parse(courseNewsResponse.publicationEnd).toLocal(),
    );
  }
  final String id;
  final String title;
  final String content;
  final DateTime publicationStart;
  final DateTime publicationEnd;
}
