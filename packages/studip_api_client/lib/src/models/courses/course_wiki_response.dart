import 'package:studip_api_client/studip_api_client.dart';

class CourseWikiPagesListResponse
    implements ItemListResponse<CourseWikiPageResponse> {
  final List<CourseWikiPageResponse> wikiPages;
  @override
  final int offset;
  @override
  final int limit;
  @override
  final int total;

  CourseWikiPagesListResponse({
    required this.wikiPages,
    required this.offset,
    required this.limit,
    required this.total,
  });

  factory CourseWikiPagesListResponse.fromJson(Map<String, dynamic> json) {
    final page = json["meta"]["page"];
    List<dynamic> rawWikiPages = json["data"];

    return CourseWikiPagesListResponse(
      wikiPages: rawWikiPages
          .map((rawWikiPage) => CourseWikiPageResponse.fromJson(rawWikiPage))
          .toList(),
      offset: page["offset"],
      limit: page["limit"],
      total: page["total"],
    );
  }

  @override
  List<CourseWikiPageResponse> get items => wikiPages;
}

class CourseWikiPageResponse {
  final String id;
  final String title;
  final String content;
  final String lastEditorId;
  final String lastEditedAt;

  CourseWikiPageResponse({
    required this.id,
    required this.title,
    required this.content,
    required this.lastEditorId,
    required this.lastEditedAt,
  });

  factory CourseWikiPageResponse.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'];
    return CourseWikiPageResponse(
      id: json['id'],
      title: attributes['id'],
      content: attributes['content'],
      lastEditorId: json['relationships']['author']['data']['id'],
      lastEditedAt: attributes['chdate'],
    );
  }
}
