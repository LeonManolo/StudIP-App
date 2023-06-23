import 'package:json_annotation/json_annotation.dart';

part 'semester_response.g.dart';

@JsonSerializable()
class SemesterResponse {

  SemesterResponse({required this.semester});

  factory SemesterResponse.fromJson(Map<String, dynamic> json) =>
      _$SemesterResponseFromJson(json);
  @JsonKey(name: 'data')
  final SemesterResponseItem semester;
}

@JsonSerializable()
class SemesterResponseItem {

  SemesterResponseItem({required this.id, required this.attributes});

  factory SemesterResponseItem.fromJson(Map<String, dynamic> json) =>
      _$SemesterResponseItemFromJson(json);
  final String id;
  final SemesterResponseItemAttributes attributes;
}

@JsonSerializable()
class SemesterResponseItemAttributes {

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
  final String title;
  final String description;
  final String start;
  final String end;

  @JsonKey(name: 'start-of-lectures')
  final String startOfLectures;

  @JsonKey(name: 'end-of-lectures')
  final String endOfLectures;
}
