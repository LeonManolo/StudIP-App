// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'semester_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SemesterResponse _$SemesterResponseFromJson(Map<String, dynamic> json) =>
    SemesterResponse(
      semester:
          SemesterResponseItem.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SemesterResponseToJson(SemesterResponse instance) =>
    <String, dynamic>{
      'data': instance.semester,
    };

SemesterResponseItem _$SemesterResponseItemFromJson(
        Map<String, dynamic> json) =>
    SemesterResponseItem(
      id: json['id'] as String,
      attributes: SemesterResponseItemAttributes.fromJson(
          json['attributes'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SemesterResponseItemToJson(
        SemesterResponseItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'attributes': instance.attributes,
    };

SemesterResponseItemAttributes _$SemesterResponseItemAttributesFromJson(
        Map<String, dynamic> json) =>
    SemesterResponseItemAttributes(
      title: json['title'] as String,
      description: json['description'] as String,
      start: json['start'] as String,
      end: json['end'] as String,
      startOfLectures: json['start-of-lectures'] as String,
      endOfLectures: json['end-of-lectures'] as String,
    );

Map<String, dynamic> _$SemesterResponseItemAttributesToJson(
        SemesterResponseItemAttributes instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'start': instance.start,
      'end': instance.end,
      'start-of-lectures': instance.startOfLectures,
      'end-of-lectures': instance.endOfLectures,
    };
