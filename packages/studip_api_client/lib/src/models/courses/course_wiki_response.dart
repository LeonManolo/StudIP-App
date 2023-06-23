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

  CourseWikiPageResponseItem({
    required this.id,
    required this.attributes,
    required this.relationships,
  });

  factory CourseWikiPageResponseItem.fromJson(Map<String, dynamic> json) =>
      _$CourseWikiPageResponseItemFromJson(json);
  final String id;
  final CourseWikiPageResponseItemAttributes attributes;
  final CourseWikiPageResponseItemRelationships relationships;

  String get lastEditorId => relationships.author.data.id;
}

@JsonSerializable()
class CourseWikiPageResponseItemAttributes {

  CourseWikiPageResponseItemAttributes({
    required this.title,
    required this.content,
    required this.lastEditedAt,
  });

  factory CourseWikiPageResponseItemAttributes.fromJson(
          Map<String, dynamic> json,) =>
      _$CourseWikiPageResponseItemAttributesFromJson(json);
  @JsonKey(name: 'keyword')
  final String title;

  final String content;

  @JsonKey(name: 'chdate')
  final String lastEditedAt;
}

@JsonSerializable()
class CourseWikiPageResponseItemRelationships {

  CourseWikiPageResponseItemRelationships({required this.author});

  factory CourseWikiPageResponseItemRelationships.fromJson(
          Map<String, dynamic> json,) =>
      _$CourseWikiPageResponseItemRelationshipsFromJson(json);
  final CourseWikiPageResponseItemRelationshipAuthor author;
}

@JsonSerializable()
class CourseWikiPageResponseItemRelationshipAuthor {

  CourseWikiPageResponseItemRelationshipAuthor({required this.data});

  factory CourseWikiPageResponseItemRelationshipAuthor.fromJson(
          Map<String, dynamic> json,) =>
      _$CourseWikiPageResponseItemRelationshipAuthorFromJson(json);
  final CourseWikiPageResponseItemRelationshipAuthorData data;
}

@JsonSerializable()
class CourseWikiPageResponseItemRelationshipAuthorData {

  CourseWikiPageResponseItemRelationshipAuthorData(
      {required this.type, required this.id,});

  factory CourseWikiPageResponseItemRelationshipAuthorData.fromJson(
          Map<String, dynamic> json,) =>
      _$CourseWikiPageResponseItemRelationshipAuthorDataFromJson(json);
  final String type;
  final String id;
}
