// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityListResponse _$ActivityListResponseFromJson(
        Map<String, dynamic> json) =>
    ActivityListResponse(
      (json['data'] as List<dynamic>)
          .map((e) => ActivityResponseItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['included'] as List<dynamic>)
          .map((e) => const ActivityListResponseIncludedConverter()
              .fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ActivityListResponseToJson(
        ActivityListResponse instance) =>
    <String, dynamic>{
      'data': instance.activityResponseItems,
      'included': instance.included
          .map(const ActivityListResponseIncludedConverter().toJson)
          .toList(),
    };

ActivityResponseItem _$ActivityResponseItemFromJson(
        Map<String, dynamic> json) =>
    ActivityResponseItem(
      id: json['id'] as String,
      attributes: ActivityResponseItemAttributes.fromJson(
          json['attributes'] as Map<String, dynamic>),
      relationships: ActivityResponseItemRelationships.fromJson(
          json['relationships'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ActivityResponseItemToJson(
        ActivityResponseItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'attributes': instance.attributes,
      'relationships': instance.relationships,
    };

ActivityResponseItemAttributes _$ActivityResponseItemAttributesFromJson(
        Map<String, dynamic> json) =>
    ActivityResponseItemAttributes(
      title: json['title'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$ActivityResponseItemAttributesToJson(
        ActivityResponseItemAttributes instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
    };

ActivityResponseItemRelationships _$ActivityResponseItemRelationshipsFromJson(
        Map<String, dynamic> json) =>
    ActivityResponseItemRelationships(
      actor: ActivityResponseItemRelationshipsIncluded.fromJson(
          json['actor'] as Map<String, dynamic>),
      object: ActivityResponseItemRelationshipsIncluded.fromJson(
          json['object'] as Map<String, dynamic>),
      context: ActivityResponseItemRelationshipsIncluded.fromJson(
          json['context'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ActivityResponseItemRelationshipsToJson(
        ActivityResponseItemRelationships instance) =>
    <String, dynamic>{
      'actor': instance.actor,
      'object': instance.object,
      'context': instance.context,
    };

ActivityResponseItemRelationshipsIncluded
    _$ActivityResponseItemRelationshipsIncludedFromJson(
            Map<String, dynamic> json) =>
        ActivityResponseItemRelationshipsIncluded(
          data: ActivityResponseItemRelationshipsData.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$ActivityResponseItemRelationshipsIncludedToJson(
        ActivityResponseItemRelationshipsIncluded instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

ActivityResponseItemRelationshipsData
    _$ActivityResponseItemRelationshipsDataFromJson(
            Map<String, dynamic> json) =>
        ActivityResponseItemRelationshipsData(
          type: json['type'] as String,
          id: json['id'] as String,
        );

Map<String, dynamic> _$ActivityResponseItemRelationshipsDataToJson(
        ActivityResponseItemRelationshipsData instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
    };
