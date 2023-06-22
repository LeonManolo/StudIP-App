// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_event_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseEventListResponse _$CourseEventListResponseFromJson(
        Map<String, dynamic> json) =>
    CourseEventListResponse(
      ResponseMeta.fromJson(json['meta'] as Map<String, dynamic>),
      (json['data'] as List<dynamic>)
          .map((e) =>
              CourseEventResponseItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CourseEventListResponseToJson(
        CourseEventListResponse instance) =>
    <String, dynamic>{
      'data': instance.items,
      'meta': instance.meta,
    };

CourseEventResponseItem _$CourseEventResponseItemFromJson(
        Map<String, dynamic> json) =>
    CourseEventResponseItem(
      json['id'] as String,
      CourseEventResponseItemAttributes.fromJson(
          json['attributes'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CourseEventResponseItemToJson(
        CourseEventResponseItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'attributes': instance.attributes,
    };

CourseEventResponseItemAttributes _$CourseEventResponseItemAttributesFromJson(
        Map<String, dynamic> json) =>
    CourseEventResponseItemAttributes(
      json['title'] as String,
      json['description'] as String,
      json['start'] as String,
      json['end'] as String,
      (json['categories'] as List<dynamic>).map((e) => e as String).toList(),
      json['location'] as String?,
    );

Map<String, dynamic> _$CourseEventResponseItemAttributesToJson(
        CourseEventResponseItemAttributes instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'start': instance.start,
      'end': instance.end,
      'categories': instance.categories,
      'location': instance.location,
    };
