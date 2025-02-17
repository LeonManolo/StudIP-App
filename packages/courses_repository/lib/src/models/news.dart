import 'package:equatable/equatable.dart';
import 'package:studip_api_client/studip_api_client.dart' as studip_api_client;
import 'package:timeago/timeago.dart' as timeago;

class CourseNewsListResponse {
  CourseNewsListResponse({required this.totalNumberOfNews, required this.news});

  final int totalNumberOfNews;
  final List<CourseNews> news;
}

class ItemAuthor extends Equatable {
  const ItemAuthor({
    required this.formattedName,
    required this.id,
    required this.avatarUrl,
  });

  final String formattedName;
  final String id;
  final String avatarUrl;

  @override
  List<Object?> get props => [formattedName, id, avatarUrl];
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
    required studip_api_client.CourseNewsResponseItem courseNewsResponse,
    required studip_api_client.UserResponseItem userResponseItem,
  }) {
    return CourseNews(
      id: courseNewsResponse.id,
      title: courseNewsResponse.attributes.title,
      content: courseNewsResponse.attributes.content,
      publicationStart:
          DateTime.parse(courseNewsResponse.attributes.publicationStart)
              .toLocal(),
      publicationEnd:
          DateTime.parse(courseNewsResponse.attributes.publicationEnd)
              .toLocal(),
      author: ItemAuthor(
        id: userResponseItem.id,
        formattedName: userResponseItem.attributes.formattedName,
        avatarUrl: userResponseItem.meta.avatar.mediumAvatarUrl,
      ),
    );
  }
  final String id;
  final String title;
  final String content;
  final DateTime publicationStart;
  final DateTime publicationEnd;
  final ItemAuthor author;

  String get formattedPublicationDate {
    timeago.setLocaleMessages('de', timeago.DeMessages());
    return timeago.format(publicationStart, locale: 'de');
  }
}
