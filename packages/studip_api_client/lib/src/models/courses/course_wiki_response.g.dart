// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_wiki_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseWikiPageListResponse _$CourseWikiPageListResponseFromJson(
        Map<String, dynamic> json) =>
    CourseWikiPageListResponse(
      wikiPages: (json['data'] as List<dynamic>)
          .map((e) =>
              CourseWikiPageResponseItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: ResponseMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CourseWikiPageListResponseToJson(
        CourseWikiPageListResponse instance) =>
    <String, dynamic>{
      'data': instance.wikiPages,
      'meta': instance.meta,
    };

CourseWikiPageResponseItem _$CourseWikiPageResponseItemFromJson(
        Map<String, dynamic> json) =>
    CourseWikiPageResponseItem(
      id: json['id'] as String,
      attributes: CourseWikiPageResponseItemAttributes.fromJson(
          json['attributes'] as Map<String, dynamic>),
      relationships: CourseWikiPageResponseItemRelationships.fromJson(
          json['relationships'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CourseWikiPageResponseItemToJson(
        CourseWikiPageResponseItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'attributes': instance.attributes,
      'relationships': instance.relationships,
    };

CourseWikiPageResponseItemAttributes
    _$CourseWikiPageResponseItemAttributesFromJson(Map<String, dynamic> json) =>
        CourseWikiPageResponseItemAttributes(
          title: json['keyword'] as String,
          content: json['content'] as String,
          lastEditedAt: json['chdate'] as String,
        );

Map<String, dynamic> _$CourseWikiPageResponseItemAttributesToJson(
        CourseWikiPageResponseItemAttributes instance) =>
    <String, dynamic>{
      'keyword': instance.title,
      'content': instance.content,
      'chdate': instance.lastEditedAt,
    };

CourseWikiPageResponseItemRelationships
    _$CourseWikiPageResponseItemRelationshipsFromJson(
            Map<String, dynamic> json) =>
        CourseWikiPageResponseItemRelationships(
          author: CourseWikiPageResponseItemRelationshipAuthor.fromJson(
              json['author'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$CourseWikiPageResponseItemRelationshipsToJson(
        CourseWikiPageResponseItemRelationships instance) =>
    <String, dynamic>{
      'author': instance.author,
    };

CourseWikiPageResponseItemRelationshipAuthor
    _$CourseWikiPageResponseItemRelationshipAuthorFromJson(
            Map<String, dynamic> json) =>
        CourseWikiPageResponseItemRelationshipAuthor(
          data: CourseWikiPageResponseItemRelationshipAuthorData.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$CourseWikiPageResponseItemRelationshipAuthorToJson(
        CourseWikiPageResponseItemRelationshipAuthor instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

CourseWikiPageResponseItemRelationshipAuthorData
    _$CourseWikiPageResponseItemRelationshipAuthorDataFromJson(
            Map<String, dynamic> json) =>
        CourseWikiPageResponseItemRelationshipAuthorData(
          type: json['type'] as String,
          id: json['id'] as String,
        );

Map<String, dynamic> _$CourseWikiPageResponseItemRelationshipAuthorDataToJson(
        CourseWikiPageResponseItemRelationshipAuthorData instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
    };
