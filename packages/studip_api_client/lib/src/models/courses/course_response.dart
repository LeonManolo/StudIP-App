import 'package:json_annotation/json_annotation.dart';
import 'package:studip_api_client/studip_api_client.dart';

part 'course_response.g.dart';

@JsonSerializable()
class CourseResponse implements ItemListResponse<CourseResponseItem> {
  @JsonKey(name: 'data')
  final List<CourseResponseItem> courses;

  CourseResponse({required this.courses, required this.meta});

  factory CourseResponse.fromJson(Map<String, dynamic> json) =>
      _$CourseResponseFromJson(json);

  @override
  @JsonKey(includeFromJson: false)
  int get offset => meta.page.offset;

  @override
  @JsonKey(includeFromJson: false)
  int get limit => meta.page.limit;

  @override
  @JsonKey(includeFromJson: false)
  int get total => meta.page.total;

  final ResponseMeta meta;

  @override
  @JsonKey(includeFromJson: false)
  List<CourseResponseItem> get items => courses;
}

@JsonSerializable()
class CourseResponseItem {
  final String id;
  final CourseResponseItemAttributes attributes;
  final CourseResponseItemRelationships relationships;

  @JsonKey(includeFromJson: false)
  String get startSemesterId => relationships.startSemester.data.id;

  CourseResponseItem({
    required this.id,
    required this.attributes,
    required this.relationships,
  });

  factory CourseResponseItem.fromJson(Map<String, dynamic> json) =>
      _$CourseResponseItemFromJson(json);
}

@JsonSerializable()
class CourseResponseItemAttributes {
  @JsonKey(name: 'course-number')
  final String? courseNumber;
  final String title;
  final String? subtitle;
  final String? description;
  final String? location;

  CourseResponseItemAttributes({
    this.courseNumber,
    required this.title,
    this.subtitle,
    this.description,
    this.location,
  });

  factory CourseResponseItemAttributes.fromJson(Map<String, dynamic> json) =>
      _$CourseResponseItemAttributesFromJson(json);
}

@JsonSerializable()
class CourseResponseItemRelationships {
  @JsonKey(name: 'start-semester')
  final CourseResponseItemRelationshipsSemester startSemester;

  @JsonKey(name: 'end-semester')
  final CourseResponseItemRelationshipsSemester endSemester;

  CourseResponseItemRelationships(
      {required this.startSemester, required this.endSemester});

  factory CourseResponseItemRelationships.fromJson(Map<String, dynamic> json) =>
      _$CourseResponseItemRelationshipsFromJson(json);
}

@JsonSerializable()
class CourseResponseItemRelationshipsSemester {
  final CourseResponseItemRelationshipsSemesterData data;

  CourseResponseItemRelationshipsSemester({required this.data});

  factory CourseResponseItemRelationshipsSemester.fromJson(
          Map<String, dynamic> json) =>
      _$CourseResponseItemRelationshipsSemesterFromJson(json);
}

@JsonSerializable()
class CourseResponseItemRelationshipsSemesterData {
  final String type;
  final String id;

  CourseResponseItemRelationshipsSemesterData(
      {required this.type, required this.id});

  factory CourseResponseItemRelationshipsSemesterData.fromJson(
          Map<String, dynamic> json) =>
      _$CourseResponseItemRelationshipsSemesterDataFromJson(json);
}
