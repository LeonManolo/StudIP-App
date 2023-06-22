// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FolderResponse _$FolderResponseFromJson(Map<String, dynamic> json) =>
    FolderResponse(
      folders: (json['data'] as List<dynamic>)
          .map((e) => FolderResponseItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: ResponseMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FolderResponseToJson(FolderResponse instance) =>
    <String, dynamic>{
      'data': instance.folders,
      'meta': instance.meta,
    };

FolderResponseItem _$FolderResponseItemFromJson(Map<String, dynamic> json) =>
    FolderResponseItem(
      id: json['id'] as String,
      attributes: FolderResponseItemAttributes.fromJson(
          json['attributes'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FolderResponseItemToJson(FolderResponseItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'attributes': instance.attributes,
    };

FolderResponseItemAttributes _$FolderResponseItemAttributesFromJson(
        Map<String, dynamic> json) =>
    FolderResponseItemAttributes(
      folderType: json['folder-type'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      createdAt: json['mkdate'] as String,
      lastUpdatedAt: json['chdate'] as String,
      isVisible: json['is-visible'] as bool,
      isReadable: json['is-readable'] as bool,
      isWritable: json['is-writable'] as bool,
      isSubfolderAllowed: json['is-subfolder-allowed'] as bool,
    );

Map<String, dynamic> _$FolderResponseItemAttributesToJson(
        FolderResponseItemAttributes instance) =>
    <String, dynamic>{
      'folder-type': instance.folderType,
      'name': instance.name,
      'description': instance.description,
      'mkdate': instance.createdAt,
      'chdate': instance.lastUpdatedAt,
      'is-visible': instance.isVisible,
      'is-readable': instance.isReadable,
      'is-writable': instance.isWritable,
      'is-subfolder-allowed': instance.isSubfolderAllowed,
    };
