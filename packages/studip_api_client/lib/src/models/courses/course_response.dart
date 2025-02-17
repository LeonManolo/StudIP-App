import 'package:json_annotation/json_annotation.dart';
import 'package:studip_api_client/studip_api_client.dart';

part 'course_response.g.dart';

@JsonSerializable()
class CourseListResponse implements ItemListResponse<CourseResponseItem> {
  CourseListResponse({required this.courses, required this.meta});

  factory CourseListResponse.fromJson(Map<String, dynamic> json) =>
      _$CourseListResponseFromJson(json);
  @JsonKey(name: 'data')
  final List<CourseResponseItem> courses;

  @override
  int get offset => meta.page.offset;

  @override
  int get limit => meta.page.limit;

  @override
  int get total => meta.page.total;

  final ResponseMeta meta;

  @override
  List<CourseResponseItem> get items => courses;
}

/// Single [CourseResponseItem] Response
@JsonSerializable()
class CourseResponse {
  CourseResponse({required this.courseResponseItem});

  factory CourseResponse.fromJson(Map<String, dynamic> json) =>
      _$CourseResponseFromJson(json);

  @JsonKey(name: 'data')
  final CourseResponseItem courseResponseItem;
}

@JsonSerializable()
class CourseResponseItem {
  CourseResponseItem({
    required this.id,
    required this.attributes,
    required this.relationships,
  });

  factory CourseResponseItem.fromJson(Map<String, dynamic> json) =>
      _$CourseResponseItemFromJson(json);
  final String id;
  final CourseResponseItemAttributes attributes;
  final CourseResponseItemRelationships relationships;

  @JsonKey(includeFromJson: false)
  String get startSemesterId => relationships.startSemester.data.id;
}

@JsonSerializable()
class CourseResponseItemAttributes {
  CourseResponseItemAttributes({
    this.courseNumber,
    required this.title,
    this.subtitle,
    this.description,
    this.location,
  });

  factory CourseResponseItemAttributes.fromJson(Map<String, dynamic> json) =>
      _$CourseResponseItemAttributesFromJson(json);
  @JsonKey(name: 'course-number')
  final String? courseNumber;
  final String title;
  final String? subtitle;
  final String? description;
  final String? location;
}

@JsonSerializable()
class CourseResponseItemRelationships {
  CourseResponseItemRelationships({
    required this.startSemester,
    required this.endSemester,
  });

  factory CourseResponseItemRelationships.fromJson(Map<String, dynamic> json) =>
      _$CourseResponseItemRelationshipsFromJson(json);
  @JsonKey(name: 'start-semester')
  final CourseResponseItemRelationshipsSemester startSemester;

  @JsonKey(name: 'end-semester')
  final CourseResponseItemRelationshipsSemester endSemester;
}

@JsonSerializable()
class CourseResponseItemRelationshipsSemester {
  CourseResponseItemRelationshipsSemester({required this.data});

  factory CourseResponseItemRelationshipsSemester.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$CourseResponseItemRelationshipsSemesterFromJson(json);
  final CourseResponseItemRelationshipsSemesterData data;
}

@JsonSerializable()
class CourseResponseItemRelationshipsSemesterData {
  CourseResponseItemRelationshipsSemesterData({
    required this.type,
    required this.id,
  });

  factory CourseResponseItemRelationshipsSemesterData.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$CourseResponseItemRelationshipsSemesterDataFromJson(json);
  final String type;
  final String id;
}
