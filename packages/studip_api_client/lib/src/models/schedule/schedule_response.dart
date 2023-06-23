import 'package:json_annotation/json_annotation.dart';

part 'schedule_response.g.dart';

@JsonSerializable()
class ScheduleListResponse {
  ScheduleListResponse({required this.scheduleEntries});

  factory ScheduleListResponse.fromJson(Map<String, dynamic> json) =>
      _$ScheduleListResponseFromJson(json);

  @JsonKey(name: 'data')
  final List<ScheduleResponseItem> scheduleEntries;
}

@JsonSerializable()
class ScheduleResponseItem {

  ScheduleResponseItem({
    required this.type,
    required this.id,
    required this.attributes,
  });

  factory ScheduleResponseItem.fromJson(Map<String, dynamic> json) =>
      _$ScheduleResponseItemFromJson(json);
  final String type;
  final String id;
  final ScheduleResponseItemAttributes attributes;
}

@JsonSerializable()
class ScheduleResponseItemAttributes {
  ScheduleResponseItemAttributes({
    required this.title,
    required this.description,
    required this.start,
    required this.end,
    required this.weekday,
    required this.locations,
    required this.recurrence,
  });

  factory ScheduleResponseItemAttributes.fromJson(Map<String, dynamic> json) =>
      _$ScheduleResponseItemAttributesFromJson(json);

  final String title;
  final String? description;
  final String start;
  final String end;
  final int weekday;
  final List<String>? locations;
  final ScheduleResponseItemAttributesRecurrence? recurrence;
}

@JsonSerializable()
class ScheduleResponseItemAttributesRecurrence {

  ScheduleResponseItemAttributesRecurrence({
    required this.freq,
    required this.interval,
    required this.firstOccurrenceDateString,
    required this.lastOccurrenceDateString,
    required this.excludedDates,
  });

  factory ScheduleResponseItemAttributesRecurrence.fromJson(
          Map<String, dynamic> json,) =>
      _$ScheduleResponseItemAttributesRecurrenceFromJson(json);
  @JsonKey(name: 'FREQ')
  final String freq;

  @JsonKey(name: 'INTERVAL')
  final int interval;

  @JsonKey(name: 'DTSTART')
  final String firstOccurrenceDateString;

  @JsonKey(name: 'UNTIL')
  final String lastOccurrenceDateString;

  @JsonKey(name: 'EXDATES')
  final List<String>? excludedDates;
}
