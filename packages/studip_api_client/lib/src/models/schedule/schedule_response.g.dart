// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleListResponse _$ScheduleListResponseFromJson(
        Map<String, dynamic> json) =>
    ScheduleListResponse(
      scheduleEntries: (json['data'] as List<dynamic>)
          .map((e) => ScheduleResponseItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ScheduleListResponseToJson(
        ScheduleListResponse instance) =>
    <String, dynamic>{
      'data': instance.scheduleEntries,
    };

ScheduleResponseItem _$ScheduleResponseItemFromJson(
        Map<String, dynamic> json) =>
    ScheduleResponseItem(
      type: json['type'] as String,
      id: json['id'] as String,
      attributes: ScheduleResponseItemAttributes.fromJson(
          json['attributes'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ScheduleResponseItemToJson(
        ScheduleResponseItem instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
      'attributes': instance.attributes,
    };

ScheduleResponseItemAttributes _$ScheduleResponseItemAttributesFromJson(
        Map<String, dynamic> json) =>
    ScheduleResponseItemAttributes(
      title: json['title'] as String,
      description: json['description'] as String?,
      start: json['start'] as String,
      end: json['end'] as String,
      weekday: json['weekday'] as int,
      locations: (json['locations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      recurrence: json['recurrence'] == null
          ? null
          : ScheduleResponseItemAttributesRecurrence.fromJson(
              json['recurrence'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ScheduleResponseItemAttributesToJson(
        ScheduleResponseItemAttributes instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'start': instance.start,
      'end': instance.end,
      'weekday': instance.weekday,
      'locations': instance.locations,
      'recurrence': instance.recurrence,
    };

ScheduleResponseItemAttributesRecurrence
    _$ScheduleResponseItemAttributesRecurrenceFromJson(
            Map<String, dynamic> json) =>
        ScheduleResponseItemAttributesRecurrence(
          freq: json['FREQ'] as String,
          interval: json['INTERVAL'] as int,
          firstOccurrenceDateString: json['DTSTART'] as String,
          lastOccurrenceDateString: json['UNTIL'] as String,
          excludedDates: (json['EXDATES'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
        );

Map<String, dynamic> _$ScheduleResponseItemAttributesRecurrenceToJson(
        ScheduleResponseItemAttributesRecurrence instance) =>
    <String, dynamic>{
      'FREQ': instance.freq,
      'INTERVAL': instance.interval,
      'DTSTART': instance.firstOccurrenceDateString,
      'UNTIL': instance.lastOccurrenceDateString,
      'EXDATES': instance.excludedDates,
    };
