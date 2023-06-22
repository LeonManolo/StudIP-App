// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_news_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseNewsListResponse _$CourseNewsListResponseFromJson(
        Map<String, dynamic> json) =>
    CourseNewsListResponse(
      items: (json['data'] as List<dynamic>)
          .map(
              (e) => CourseNewsResponseItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: ResponseMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CourseNewsListResponseToJson(
        CourseNewsListResponse instance) =>
    <String, dynamic>{
      'data': instance.items,
      'meta': instance.meta,
    };

CourseNewsResponseItem _$CourseNewsResponseItemFromJson(
        Map<String, dynamic> json) =>
    CourseNewsResponseItem(
      id: json['id'] as String,
      attributes: CourseNewsResponseItemAttributes.fromJson(
          json['attributes'] as Map<String, dynamic>),
      relationships: CourseNewsResponseItemRelationships.fromJson(
          json['relationships'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CourseNewsResponseItemToJson(
        CourseNewsResponseItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'attributes': instance.attributes,
      'relationships': instance.relationships,
    };

CourseNewsResponseItemAttributes _$CourseNewsResponseItemAttributesFromJson(
        Map<String, dynamic> json) =>
    CourseNewsResponseItemAttributes(
      title: json['title'] as String,
      content: json['content'] as String,
      publicationStart: json['publication-start'] as String,
      publicationEnd: json['publication-end'] as String,
    );

Map<String, dynamic> _$CourseNewsResponseItemAttributesToJson(
        CourseNewsResponseItemAttributes instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'publication-start': instance.publicationStart,
      'publication-end': instance.publicationEnd,
    };

CourseNewsResponseItemRelationships
    _$CourseNewsResponseItemRelationshipsFromJson(Map<String, dynamic> json) =>
        CourseNewsResponseItemRelationships(
          author: CourseNewsResponseItemRelationshipAuthor.fromJson(
              json['author'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$CourseNewsResponseItemRelationshipsToJson(
        CourseNewsResponseItemRelationships instance) =>
    <String, dynamic>{
      'author': instance.author,
    };

CourseNewsResponseItemRelationshipAuthor
    _$CourseNewsResponseItemRelationshipAuthorFromJson(
            Map<String, dynamic> json) =>
        CourseNewsResponseItemRelationshipAuthor(
          data: CourseNewsResponseItemRelationshipAuthorData.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$CourseNewsResponseItemRelationshipAuthorToJson(
        CourseNewsResponseItemRelationshipAuthor instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

CourseNewsResponseItemRelationshipAuthorData
    _$CourseNewsResponseItemRelationshipAuthorDataFromJson(
            Map<String, dynamic> json) =>
        CourseNewsResponseItemRelationshipAuthorData(
          type: json['type'] as String,
          id: json['id'] as String,
        );

Map<String, dynamic> _$CourseNewsResponseItemRelationshipAuthorDataToJson(
        CourseNewsResponseItemRelationshipAuthorData instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
    };
