import 'package:courses_repository/courses_repository.dart';
import 'package:studip_api_client/studip_api_client.dart' as studip_api_client;
import 'package:timeago/timeago.dart' as timeago;

class NewsActivity {
  NewsActivity({
    required this.createDate,
    required this.content,
    required this.verb,
    required this.title,
    required this.courseId,
    required this.userId,
    this.course,
    this.userName,
  });
  factory NewsActivity.fromNewsActivityResponse({
    required studip_api_client.NewsActivityResponse newsActivityResponse,
  }) {
    return NewsActivity(
      createDate: DateTime.parse(newsActivityResponse.createDate).toLocal(),
      content: newsActivityResponse.content,
      verb: newsActivityResponse.verb,
      title: newsActivityResponse.title,
      courseId: newsActivityResponse.courseId,
      userId: newsActivityResponse.userId,
    );
  }
  final DateTime createDate;
  final String content;
  final String verb;
  final String title;
  final String courseId;
  final String userId;
  Course? course;
  String? userName;

  String getTimeAgo() {
    timeago.setLocaleMessages('de', timeago.DeMessages());
    return timeago.format(createDate, locale: 'de');
  }
}
