import 'package:json_annotation/json_annotation.dart';
import 'package:studip_api_client/studip_api_client.dart';

part 'course_event_response.g.dart';

@JsonSerializable()
class CourseEventListResponse
    implements ItemListResponse<CourseEventResponseItem> {
  CourseEventListResponse(this.meta, this.items);

  factory CourseEventListResponse.fromJson(Map<String, dynamic> json) =>
      _$CourseEventListResponseFromJson(json);

  @override
  int get limit => meta.page.limit;

  @override
  int get offset => meta.page.offset;

  @override
  int get total => meta.page.total;

  @override
  @JsonKey(name: 'data')
  final List<CourseEventResponseItem> items;

  final ResponseMeta meta;
}

@JsonSerializable()
class CourseEventResponseItem {
  CourseEventResponseItem(this.id, this.attributes);

  factory CourseEventResponseItem.fromJson(Map<String, dynamic> json) =>
      _$CourseEventResponseItemFromJson(json);

  final String id;
  final CourseEventResponseItemAttributes attributes;
}

@JsonSerializable()
class CourseEventResponseItemAttributes {
  CourseEventResponseItemAttributes(
    this.title,
    this.description,
    this.start,
    this.end,
    this.categories,
    this.location,
  );

  factory CourseEventResponseItemAttributes.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$CourseEventResponseItemAttributesFromJson(json);

  final String title;
  final String description;
  final String start;
  final String end;
  final List<String> categories;
  final String? location;
}
