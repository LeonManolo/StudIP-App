// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseListResponse _$CourseListResponseFromJson(Map<String, dynamic> json) =>
    CourseListResponse(
      courses: (json['data'] as List<dynamic>)
          .map((e) => CourseResponseItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: ResponseMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CourseListResponseToJson(CourseListResponse instance) =>
    <String, dynamic>{
      'data': instance.courses,
      'meta': instance.meta,
    };

CourseResponseItem _$CourseResponseItemFromJson(Map<String, dynamic> json) =>
    CourseResponseItem(
      id: json['id'] as String,
      attributes: CourseResponseItemAttributes.fromJson(
          json['attributes'] as Map<String, dynamic>),
      relationships: CourseResponseItemRelationships.fromJson(
          json['relationships'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CourseResponseItemToJson(CourseResponseItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'attributes': instance.attributes,
      'relationships': instance.relationships,
    };

CourseResponseItemAttributes _$CourseResponseItemAttributesFromJson(
        Map<String, dynamic> json) =>
    CourseResponseItemAttributes(
      courseNumber: json['course-number'] as String?,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      description: json['description'] as String?,
      location: json['location'] as String?,
    );

Map<String, dynamic> _$CourseResponseItemAttributesToJson(
        CourseResponseItemAttributes instance) =>
    <String, dynamic>{
      'course-number': instance.courseNumber,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'description': instance.description,
      'location': instance.location,
    };

CourseResponseItemRelationships _$CourseResponseItemRelationshipsFromJson(
        Map<String, dynamic> json) =>
    CourseResponseItemRelationships(
      startSemester: CourseResponseItemRelationshipsSemester.fromJson(
          json['start-semester'] as Map<String, dynamic>),
      endSemester: CourseResponseItemRelationshipsSemester.fromJson(
          json['end-semester'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CourseResponseItemRelationshipsToJson(
        CourseResponseItemRelationships instance) =>
    <String, dynamic>{
      'start-semester': instance.startSemester,
      'end-semester': instance.endSemester,
    };

CourseResponseItemRelationshipsSemester
    _$CourseResponseItemRelationshipsSemesterFromJson(
            Map<String, dynamic> json) =>
        CourseResponseItemRelationshipsSemester(
          data: CourseResponseItemRelationshipsSemesterData.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$CourseResponseItemRelationshipsSemesterToJson(
        CourseResponseItemRelationshipsSemester instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

CourseResponseItemRelationshipsSemesterData
    _$CourseResponseItemRelationshipsSemesterDataFromJson(
            Map<String, dynamic> json) =>
        CourseResponseItemRelationshipsSemesterData(
          type: json['type'] as String,
          id: json['id'] as String,
        );

Map<String, dynamic> _$CourseResponseItemRelationshipsSemesterDataToJson(
        CourseResponseItemRelationshipsSemesterData instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
    };
