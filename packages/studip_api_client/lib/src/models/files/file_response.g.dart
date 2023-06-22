// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileListResponse _$FileListResponseFromJson(Map<String, dynamic> json) =>
    FileListResponse(
      files: (json['data'] as List<dynamic>)
          .map((e) => FileResponseItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: ResponseMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FileListResponseToJson(FileListResponse instance) =>
    <String, dynamic>{
      'data': instance.files,
      'meta': instance.meta,
    };

FileResponseItem _$FileResponseItemFromJson(Map<String, dynamic> json) =>
    FileResponseItem(
      id: json['id'] as String,
      attributes: FileResponseItemAttributes.fromJson(
          json['attributes'] as Map<String, dynamic>),
      relationships: FileResponseItemRelationships.fromJson(
          json['relationships'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FileResponseItemToJson(FileResponseItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'attributes': instance.attributes,
      'relationships': instance.relationships,
    };

FileResponseItemAttributes _$FileResponseItemAttributesFromJson(
        Map<String, dynamic> json) =>
    FileResponseItemAttributes(
      name: json['name'] as String,
      description: json['description'] as String,
      numberOfDownloads: json['downloads'] as int,
      createdAt: json['mkdate'] as String,
      lastUpdatedAt: json['chdate'] as String,
      mimeType: json['mime-type'] as String,
      isReadable: json['is-readable'] as bool,
      isDownloadable: json['is-downloadable'] as bool,
    );

Map<String, dynamic> _$FileResponseItemAttributesToJson(
        FileResponseItemAttributes instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'downloads': instance.numberOfDownloads,
      'mkdate': instance.createdAt,
      'chdate': instance.lastUpdatedAt,
      'mime-type': instance.mimeType,
      'is-readable': instance.isReadable,
      'is-downloadable': instance.isDownloadable,
    };

FileResponseItemRelationships _$FileResponseItemRelationshipsFromJson(
        Map<String, dynamic> json) =>
    FileResponseItemRelationships(
      owner:
          FileResponseItemOwner.fromJson(json['owner'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FileResponseItemRelationshipsToJson(
        FileResponseItemRelationships instance) =>
    <String, dynamic>{
      'owner': instance.owner,
    };

FileResponseItemOwner _$FileResponseItemOwnerFromJson(
        Map<String, dynamic> json) =>
    FileResponseItemOwner(
      meta: FileResponseItemOwnerMeta.fromJson(
          json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FileResponseItemOwnerToJson(
        FileResponseItemOwner instance) =>
    <String, dynamic>{
      'meta': instance.meta,
    };

FileResponseItemOwnerMeta _$FileResponseItemOwnerMetaFromJson(
        Map<String, dynamic> json) =>
    FileResponseItemOwnerMeta(
      name: json['name'] as String,
    );

Map<String, dynamic> _$FileResponseItemOwnerMetaToJson(
        FileResponseItemOwnerMeta instance) =>
    <String, dynamic>{
      'name': instance.name,
    };
