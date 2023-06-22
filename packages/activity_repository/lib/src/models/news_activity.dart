import 'package:courses_repository/courses_repository.dart';
import 'package:studip_api_client/studip_api_client.dart' as studip_api_client;
import 'package:timeago/timeago.dart' as timeago;

class NewsActivity {
  NewsActivity({
    required this.createDate,
    required this.title,
    required this.publicationEnd,
    required this.course,
    required this.username,
  });
  factory NewsActivity.fromNewsActivityResponse({
    required studip_api_client.NewsActivityResponse newsActivityResponse,
  }) {
    return NewsActivity(
      createDate: DateTime.parse(newsActivityResponse.createDate).toLocal(),
      title: newsActivityResponse.title,
      username: newsActivityResponse.username,
      publicationEnd: newsActivityResponse.publicationEnd,
      course: Course.fromCourseResponse(
        studip_api_client.CourseResponseItem.fromJson(
          newsActivityResponse.course,
        ),
      ),
    );
  }
  final DateTime createDate;
  final String title;
  final DateTime publicationEnd;
  Course course;
  String username;

  String getTimeAgo() {
    timeago.setLocaleMessages('de', timeago.DeMessages());
    return timeago.format(createDate, locale: 'de');
  }
}
