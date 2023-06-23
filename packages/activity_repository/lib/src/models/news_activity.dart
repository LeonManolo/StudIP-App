import 'package:courses_repository/courses_repository.dart';
import 'package:studip_api_client/studip_api_client.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsActivity {
  NewsActivity({
    required this.publicationStart,
    required this.title,
    required this.publicationEnd,
    required this.course,
    required this.username,
  });
  factory NewsActivity.fromNewsActivityResponse({
    required CourseNewsResponseItem newsResponseItem,
    required UserResponseItem userResponseItem,
    required CourseResponseItem courseResponseItem,
  }) {
    return NewsActivity(
      publicationStart:
          DateTime.parse(newsResponseItem.attributes.publicationStart)
              .toLocal(),
      title: newsResponseItem.attributes.title,
      username: userResponseItem.attributes.username,
      publicationEnd:
          DateTime.parse(newsResponseItem.attributes.publicationEnd).toLocal(),
      course: Course.fromCourseResponseItem(courseResponseItem),
    );
  }
  final DateTime publicationStart;
  final String title;
  final DateTime publicationEnd;
  Course course;
  String username;

  String getTimeAgo() {
    timeago.setLocaleMessages('de', timeago.DeMessages());
    return timeago.format(publicationStart, locale: 'de');
  }
}
