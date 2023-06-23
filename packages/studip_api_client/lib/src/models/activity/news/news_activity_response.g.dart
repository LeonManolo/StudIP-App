// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_activity_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsActivityListResponse _$NewsActivityListResponseFromJson(
        Map<String, dynamic> json) =>
    NewsActivityListResponse(
      (json['data'] as List<dynamic>)
          .map((e) =>
              NewsActivityResponseItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['included'] as List<dynamic>)
          .map((e) => const NewsActivityListResponseIncludedConverter()
              .fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NewsActivityListResponseToJson(
        NewsActivityListResponse instance) =>
    <String, dynamic>{
      'data': instance.newsActivityResponseItems,
      'included': instance.included
          .map(const NewsActivityListResponseIncludedConverter().toJson)
          .toList(),
    };

NewsActivityResponseItem _$NewsActivityResponseItemFromJson(
        Map<String, dynamic> json) =>
    NewsActivityResponseItem(
      id: json['id'] as String,
      attributes: NewsActivityResponseItemAttributes.fromJson(
          json['attributes'] as Map<String, dynamic>),
      relationships: NewsActivityResponseItemRelationships.fromJson(
          json['relationships'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NewsActivityResponseItemToJson(
        NewsActivityResponseItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'attributes': instance.attributes,
      'relationships': instance.relationships,
    };

NewsActivityResponseItemAttributes _$NewsActivityResponseItemAttributesFromJson(
        Map<String, dynamic> json) =>
    NewsActivityResponseItemAttributes(
      title: json['title'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$NewsActivityResponseItemAttributesToJson(
        NewsActivityResponseItemAttributes instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
    };

NewsActivityResponseItemRelationships
    _$NewsActivityResponseItemRelationshipsFromJson(
            Map<String, dynamic> json) =>
        NewsActivityResponseItemRelationships(
          user: NewsActivityResponseItemRelationshipsIncluded.fromJson(
              json['actor'] as Map<String, dynamic>),
          news: NewsActivityResponseItemRelationshipsIncluded.fromJson(
              json['object'] as Map<String, dynamic>),
          course: NewsActivityResponseItemRelationshipsIncluded.fromJson(
              json['context'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$NewsActivityResponseItemRelationshipsToJson(
        NewsActivityResponseItemRelationships instance) =>
    <String, dynamic>{
      'actor': instance.user,
      'object': instance.news,
      'context': instance.course,
    };

NewsActivityResponseItemRelationshipsIncluded
    _$NewsActivityResponseItemRelationshipsIncludedFromJson(
            Map<String, dynamic> json) =>
        NewsActivityResponseItemRelationshipsIncluded(
          data: NewsActivityResponseItemRelationshipsData.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$NewsActivityResponseItemRelationshipsIncludedToJson(
        NewsActivityResponseItemRelationshipsIncluded instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

NewsActivityResponseItemRelationshipsData
    _$NewsActivityResponseItemRelationshipsDataFromJson(
            Map<String, dynamic> json) =>
        NewsActivityResponseItemRelationshipsData(
          type: json['type'] as String,
          id: json['id'] as String,
        );

Map<String, dynamic> _$NewsActivityResponseItemRelationshipsDataToJson(
        NewsActivityResponseItemRelationshipsData instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
    };
