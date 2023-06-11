import 'package:courses_repository/src/models/news.dart';
import 'package:studip_api_client/studip_api_client.dart' as studip_api_client;
import 'package:timeago/timeago.dart' as timeago;

class CourseWikiPageData {
  CourseWikiPageData({
    required this.id,
    required this.title,
    required this.content,
    required this.lastEditorAuthor,
    required this.lastEditedAt,
  });

  factory CourseWikiPageData.fromCourseWikiPageResponse({
    required studip_api_client.CourseWikiPageResponse courseWikiPageResponse,
    required studip_api_client.UserResponse userResponse,
  }) {
    return CourseWikiPageData(
      id: courseWikiPageResponse.id,
      title: courseWikiPageResponse.title,
      content: courseWikiPageResponse.content,
      lastEditorAuthor: ItemAuthor(
        formattedName: userResponse.formattedName,
        id: userResponse.id,
        avatarUrl: userResponse.avatarUrl,
      ),
      lastEditedAt:
          DateTime.parse(courseWikiPageResponse.lastEditedAt).toLocal(),
    );
  }

  final String id;
  String title;
  final String content;
  final ItemAuthor lastEditorAuthor;
  final DateTime lastEditedAt;

  String get formattedLastEditedDate {
    timeago.setLocaleMessages('de', timeago.DeMessages());
    return timeago.format(lastEditedAt, locale: 'de');
  }
}
