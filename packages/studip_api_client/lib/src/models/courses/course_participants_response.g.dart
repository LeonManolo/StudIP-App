// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_participants_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseParticipantsListResponse _$CourseParticipantsListResponseFromJson(
        Map<String, dynamic> json) =>
    CourseParticipantsListResponse(
      meta: ResponseMeta.fromJson(json['meta'] as Map<String, dynamic>),
      participants: (json['data'] as List<dynamic>)
          .map((e) => CourseParticipantsResponseItem.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CourseParticipantsListResponseToJson(
        CourseParticipantsListResponse instance) =>
    <String, dynamic>{
      'meta': instance.meta,
      'data': instance.participants,
    };

CourseParticipantsResponseItem _$CourseParticipantsResponseItemFromJson(
        Map<String, dynamic> json) =>
    CourseParticipantsResponseItem(
      type: json['type'] as String,
      id: CourseParticipantsResponseItem._idFromJson(json['id'] as String),
    );

Map<String, dynamic> _$CourseParticipantsResponseItemToJson(
        CourseParticipantsResponseItem instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
    };
