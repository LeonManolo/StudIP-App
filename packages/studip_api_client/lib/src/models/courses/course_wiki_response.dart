import 'package:json_annotation/json_annotation.dart';
import 'package:studip_api_client/studip_api_client.dart';

part 'course_wiki_response.g.dart';

@JsonSerializable()
class CourseWikiPageListResponse
    implements ItemListResponse<CourseWikiPageResponseItem> {
  CourseWikiPageListResponse({required this.wikiPages, required this.meta});

  factory CourseWikiPageListResponse.fromJson(Map<String, dynamic> json) =>
      _$CourseWikiPageListResponseFromJson(json);

  @JsonKey(name: 'data')
  final List<CourseWikiPageResponseItem> wikiPages;

  @override
  @JsonKey(includeFromJson: false)
  int get offset => meta.page.offset;

  @override
  @JsonKey(includeFromJson: false)
  int get limit => meta.page.limit;

  @override
  @JsonKey(includeFromJson: false)
  int get total => meta.page.total;

  final ResponseMeta meta;

  @override
  @JsonKey(includeFromJson: false)
  List<CourseWikiPageResponseItem> get items => wikiPages;
}

@JsonSerializable()
class CourseWikiPageResponseItem {
  final String id;
  final CourseWikiPageResponseItemAttributes attributes;
  final CourseWikiPageResponseItemRelationships relationships;

  String get lastEditorId => relationships.author.data.id;

  factory CourseWikiPageResponseItem.fromJson(Map<String, dynamic> json) =>
      _$CourseWikiPageResponseItemFromJson(json);

  CourseWikiPageResponseItem({
    required this.id,
    required this.attributes,
    required this.relationships,
  });
}

@JsonSerializable()
class CourseWikiPageResponseItemAttributes {
  @JsonKey(name: 'keyword')
  final String title;

  final String content;

  @JsonKey(name: 'chdate')
  final String lastEditedAt;

  factory CourseWikiPageResponseItemAttributes.fromJson(
          Map<String, dynamic> json) =>
      _$CourseWikiPageResponseItemAttributesFromJson(json);

  CourseWikiPageResponseItemAttributes({
    required this.title,
    required this.content,
    required this.lastEditedAt,
  });
}

@JsonSerializable()
class CourseWikiPageResponseItemRelationships {
  final CourseWikiPageResponseItemRelationshipAuthor author;

  factory CourseWikiPageResponseItemRelationships.fromJson(
          Map<String, dynamic> json) =>
      _$CourseWikiPageResponseItemRelationshipsFromJson(json);

  CourseWikiPageResponseItemRelationships({required this.author});
}

@JsonSerializable()
class CourseWikiPageResponseItemRelationshipAuthor {
  final CourseWikiPageResponseItemRelationshipAuthorData data;

  factory CourseWikiPageResponseItemRelationshipAuthor.fromJson(
          Map<String, dynamic> json) =>
      _$CourseWikiPageResponseItemRelationshipAuthorFromJson(json);

  CourseWikiPageResponseItemRelationshipAuthor({required this.data});
}

@JsonSerializable()
class CourseWikiPageResponseItemRelationshipAuthorData {
  final String type;
  final String id;

  factory CourseWikiPageResponseItemRelationshipAuthorData.fromJson(
          Map<String, dynamic> json) =>
      _$CourseWikiPageResponseItemRelationshipAuthorDataFromJson(json);

  CourseWikiPageResponseItemRelationshipAuthorData(
      {required this.type, required this.id});
}
