import 'package:json_annotation/json_annotation.dart';
import 'package:studip_api_client/studip_api_client.dart';

part 'course_news_response.g.dart';

@JsonSerializable()
class CourseNewsResponse implements ItemListResponse<CourseNewsResponseItem> {
  CourseNewsResponse({required this.items, required this.meta});

  factory CourseNewsResponse.fromJson(Map<String, dynamic> json) =>
      _$CourseNewsResponseFromJson(json);

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
  final String id;
  final CourseNewsResponseItemAttributes attributes;
  final CourseNewsResponseItemRelationships relationships;

  @JsonKey(includeFromJson: false)
  String get authorId => relationships.author.data.id;

  CourseNewsResponseItem({
    required this.id,
    required this.attributes,
    required this.relationships,
  });

  factory CourseNewsResponseItem.fromJson(Map<String, dynamic> json) =>
      _$CourseNewsResponseItemFromJson(json);
}

@JsonSerializable()
class CourseNewsResponseItemAttributes {
  final String title;
  final String content;
  @JsonKey(name: 'publication-start')
  final String publicationStart;
  @JsonKey(name: 'publication-end')
  final String publicationEnd;

  CourseNewsResponseItemAttributes({
    required this.title,
    required this.content,
    required this.publicationStart,
    required this.publicationEnd,
  });

  factory CourseNewsResponseItemAttributes.fromJson(
          Map<String, dynamic> json) =>
      _$CourseNewsResponseItemAttributesFromJson(json);
}

@JsonSerializable()
class CourseNewsResponseItemRelationships {
  final CourseNewsResponseItemRelationshipAuthor author;

  CourseNewsResponseItemRelationships({required this.author});

  factory CourseNewsResponseItemRelationships.fromJson(
          Map<String, dynamic> json) =>
      _$CourseNewsResponseItemRelationshipsFromJson(json);
}

@JsonSerializable()
class CourseNewsResponseItemRelationshipAuthor {
  final CourseNewsResponseItemRelationshipAuthorData data;

  CourseNewsResponseItemRelationshipAuthor({required this.data});

  factory CourseNewsResponseItemRelationshipAuthor.fromJson(
          Map<String, dynamic> json) =>
      _$CourseNewsResponseItemRelationshipAuthorFromJson(json);
}

@JsonSerializable()
class CourseNewsResponseItemRelationshipAuthorData {
  final String type;
  final String id;

  CourseNewsResponseItemRelationshipAuthorData({
    required this.type,
    required this.id,
  });

  factory CourseNewsResponseItemRelationshipAuthorData.fromJson(
          Map<String, dynamic> json) =>
      _$CourseNewsResponseItemRelationshipAuthorDataFromJson(json);
}
