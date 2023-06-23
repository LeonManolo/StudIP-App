import 'package:json_annotation/json_annotation.dart';
import 'package:studip_api_client/studip_api_client.dart';

part 'course_news_response.g.dart';

@JsonSerializable()
class CourseNewsListResponse
    implements ItemListResponse<CourseNewsResponseItem> {
  CourseNewsListResponse({required this.items, required this.meta});

  factory CourseNewsListResponse.fromJson(Map<String, dynamic> json) =>
      _$CourseNewsListResponseFromJson(json);

  @override
  @JsonKey(includeFromJson: false)
  int get offset => meta.page.offset;

  @override
  @JsonKey(includeFromJson: false)
  int get limit => meta.page.limit;

  @override
  @JsonKey(includeFromJson: false)
  int get total => meta.page.total;

  @override
  @JsonKey(name: 'data')
  final List<CourseNewsResponseItem> items;

  final ResponseMeta meta;
}

@JsonSerializable()
class CourseNewsResponseItem {

  CourseNewsResponseItem({
    required this.id,
    required this.attributes,
    required this.relationships,
  });

  factory CourseNewsResponseItem.fromJson(Map<String, dynamic> json) =>
      _$CourseNewsResponseItemFromJson(json);
  final String id;
  final CourseNewsResponseItemAttributes attributes;
  final CourseNewsResponseItemRelationships relationships;

  @JsonKey(includeFromJson: false)
  String get authorId => relationships.author.data.id;
}

@JsonSerializable()
class CourseNewsResponseItemAttributes {

  CourseNewsResponseItemAttributes({
    required this.title,
    required this.content,
    required this.publicationStart,
    required this.publicationEnd,
  });

  factory CourseNewsResponseItemAttributes.fromJson(
          Map<String, dynamic> json,) =>
      _$CourseNewsResponseItemAttributesFromJson(json);
  final String title;
  final String content;
  @JsonKey(name: 'publication-start')
  final String publicationStart;
  @JsonKey(name: 'publication-end')
  final String publicationEnd;
}

@JsonSerializable()
class CourseNewsResponseItemRelationships {

  CourseNewsResponseItemRelationships({required this.author});

  factory CourseNewsResponseItemRelationships.fromJson(
          Map<String, dynamic> json,) =>
      _$CourseNewsResponseItemRelationshipsFromJson(json);
  final CourseNewsResponseItemRelationshipAuthor author;
}

@JsonSerializable()
class CourseNewsResponseItemRelationshipAuthor {

  CourseNewsResponseItemRelationshipAuthor({required this.data});

  factory CourseNewsResponseItemRelationshipAuthor.fromJson(
          Map<String, dynamic> json,) =>
      _$CourseNewsResponseItemRelationshipAuthorFromJson(json);
  final CourseNewsResponseItemRelationshipAuthorData data;
}

@JsonSerializable()
class CourseNewsResponseItemRelationshipAuthorData {

  CourseNewsResponseItemRelationshipAuthorData({
    required this.type,
    required this.id,
  });

  factory CourseNewsResponseItemRelationshipAuthorData.fromJson(
          Map<String, dynamic> json,) =>
      _$CourseNewsResponseItemRelationshipAuthorDataFromJson(json);
  final String type;
  final String id;
}
