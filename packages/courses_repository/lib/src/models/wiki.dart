import 'package:courses_repository/src/models/news.dart';
import 'package:equatable/equatable.dart';
import 'package:studip_api_client/studip_api_client.dart' as studip_api_client;
import 'package:timeago/timeago.dart' as timeago;

class CourseWikiPageData extends Equatable {
  CourseWikiPageData({
    required this.id,
    required this.title,
    required this.content,
    required this.lastEditorAuthor,
    required this.lastEditedAt,
  });

  factory CourseWikiPageData.fromCourseWikiPageResponse({
    required studip_api_client.CourseWikiPageResponseItem
        courseWikiPageResponse,
    required studip_api_client.UserResponseItem userResponseItem,
  }) {
    return CourseWikiPageData(
      id: courseWikiPageResponse.id,
      title: courseWikiPageResponse.attributes.title,
      content: courseWikiPageResponse.attributes.content,
      lastEditorAuthor: ItemAuthor(
        id: userResponseItem.id,
        formattedName: userResponseItem.attributes.formattedName,
        avatarUrl: userResponseItem.meta.avatar.mediumAvatarUrl,
      ),
      lastEditedAt:
          DateTime.parse(courseWikiPageResponse.attributes.lastEditedAt)
              .toLocal(),
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

  CourseWikiPageData updateTitle({required String newTitle}) {
    return CourseWikiPageData(
      id: id,
      title: newTitle,
      content: content,
      lastEditorAuthor: lastEditorAuthor,
      lastEditedAt: lastEditedAt,
    );
  }

  @override
  List<Object?> get props =>
      [id, title, content, lastEditorAuthor, lastEditedAt];
}
