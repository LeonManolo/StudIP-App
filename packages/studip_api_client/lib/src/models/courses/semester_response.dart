import 'package:json_annotation/json_annotation.dart';

part 'semester_response.g.dart';

@JsonSerializable()
class SemesterResponse {
  @JsonKey(name: 'data')
  final SemesterResponseItem semester;

  SemesterResponse({required this.semester});

  factory SemesterResponse.fromJson(Map<String, dynamic> json) =>
      _$SemesterResponseFromJson(json);
}

@JsonSerializable()
class SemesterResponseItem {
  final String id;
  final SemesterResponseItemAttributes attributes;

  SemesterResponseItem({required this.id, required this.attributes});

  factory SemesterResponseItem.fromJson(Map<String, dynamic> json) =>
      _$SemesterResponseItemFromJson(json);
}

@JsonSerializable()
class SemesterResponseItemAttributes {
  final String title;
  final String description;
  final String start;
  final String end;

  @JsonKey(name: 'start-of-lectures')
  final String startOfLectures;

  @JsonKey(name: 'end-of-lectures')
  final String endOfLectures;

  SemesterResponseItemAttributes({
    required this.title,
    required this.description,
    required this.start,
    required this.end,
    required this.startOfLectures,
    required this.endOfLectures,
  });

  factory SemesterResponseItemAttributes.fromJson(Map<String, dynamic> json) =>
      _$SemesterResponseItemAttributesFromJson(json);
}
