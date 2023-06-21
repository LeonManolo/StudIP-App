// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseMeta _$ResponseMetaFromJson(Map<String, dynamic> json) => ResponseMeta(
      page: ResponsePage.fromJson(json['page'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResponseMetaToJson(ResponseMeta instance) =>
    <String, dynamic>{
      'page': instance.page,
    };

ResponsePage _$ResponsePageFromJson(Map<String, dynamic> json) => ResponsePage(
      offset: json['offset'] as int,
      limit: json['limit'] as int,
      total: json['total'] as int,
    );

Map<String, dynamic> _$ResponsePageToJson(ResponsePage instance) =>
    <String, dynamic>{
      'offset': instance.offset,
      'limit': instance.limit,
      'total': instance.total,
    };
