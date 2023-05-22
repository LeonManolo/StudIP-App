import 'package:courses_repository/src/models/news.dart';
import 'package:studip_api_client/studip_api_client.dart' as studip_api_client;
import 'package:timeago/timeago.dart' as timeago;

class CourseWikiPagesListResponse {
  CourseWikiPagesListResponse({
    required this.totalNumberOfWikiPages,
    required this.wikiPages,
  });

  final int totalNumberOfWikiPages;
  final List<CourseWikiPage> wikiPages;
}

class CourseWikiPage {
  CourseWikiPage({
    required this.id,
    required this.title,
    required this.content,
    required this.lastEditorAuthor,
    required this.lastEditedAt,
  });

  factory CourseWikiPage.fromCourseWikiPageResponse({
    required studip_api_client.CourseWikiPageResponse courseWikiPageResponse,
    required studip_api_client.UserResponse userResponse,
  }) {
    return CourseWikiPage(
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
  final String title;
  final String content;
  final ItemAuthor lastEditorAuthor;
  final DateTime lastEditedAt;

  String get formattedLastEditedDate {
    timeago.setLocaleMessages('de', timeago.DeMessages());
    return timeago.format(lastEditedAt, locale: 'de');
  }
}
