import 'package:studip_api_client/studip_api_client.dart' as studip_api_client;
import 'package:timeago/timeago.dart' as timeago;

class CourseNewsListResponse {
  CourseNewsListResponse({required this.totalNumberOfNews, required this.news});

  final int totalNumberOfNews;
  final List<CourseNews> news;
}

class NewsAuthor {
  NewsAuthor({
    required this.formattedName,
    required this.id,
    required this.avatarUrl,
  });

  final String formattedName;
  final String id;
  final String avatarUrl;
}

class CourseNews {
  CourseNews({
    required this.id,
    required this.title,
    required this.content,
    required this.publicationStart,
    required this.publicationEnd,
    required this.author,
  });

  factory CourseNews.fromCourseNewsResponse({
    required studip_api_client.CourseNewsResponse courseNewsResponse,
    required studip_api_client.UserResponse userResponse,
  }) {
    return CourseNews(
      id: courseNewsResponse.id,
      title: courseNewsResponse.title,
      content: courseNewsResponse.content,
      publicationStart:
          DateTime.parse(courseNewsResponse.publicationStart).toLocal(),
      publicationEnd:
          DateTime.parse(courseNewsResponse.publicationEnd).toLocal(),
      author: NewsAuthor(
        formattedName: userResponse.formattedName,
        id: userResponse.id,
        avatarUrl: userResponse.avatarUrl,
      ),
    );
  }
  final String id;
  final String title;
  final String content;
  final DateTime publicationStart;
  final DateTime publicationEnd;
  final NewsAuthor author;

  String get formattedPublicationDate {
    timeago.setLocaleMessages('de', timeago.DeMessages());
    return timeago.format(publicationStart, locale: 'de');
  }
}
