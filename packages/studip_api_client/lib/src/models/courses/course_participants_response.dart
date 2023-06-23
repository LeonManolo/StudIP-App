import 'package:json_annotation/json_annotation.dart';
import 'package:studip_api_client/studip_api_client.dart';

part 'course_participants_response.g.dart';

@JsonSerializable()
class CourseParticipantsListResponse {

  CourseParticipantsListResponse(
      {required this.meta, required this.participants,});
  factory CourseParticipantsListResponse.fromJson(Map<String, dynamic> json) =>
      _$CourseParticipantsListResponseFromJson(json);
  final ResponseMeta meta;

  @JsonKey(name: 'data')
  final List<CourseParticipantsResponseItem> participants;
}

@JsonSerializable()
class CourseParticipantsResponseItem {

  const CourseParticipantsResponseItem({required this.type, required this.id});

  factory CourseParticipantsResponseItem.fromJson(Map<String, dynamic> json) =>
      _$CourseParticipantsResponseItemFromJson(json);
  final String type;

  @JsonKey(fromJson: _idFromJson)
  final String id;

  static String _idFromJson(String combinedCourseUserId) =>
      combinedCourseUserId.split('_').last;
}
