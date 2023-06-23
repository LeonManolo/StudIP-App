import 'package:json_annotation/json_annotation.dart';
import 'package:studip_api_client/studip_api_client.dart';

part 'file_response.g.dart';

@JsonSerializable()
class FileListResponse implements ItemListResponse<FileResponseItem> {

  FileListResponse({required this.files, required this.meta});

  factory FileListResponse.fromJson(Map<String, dynamic> json) =>
      _$FileListResponseFromJson(json);
  @JsonKey(name: 'data')
  final List<FileResponseItem> files;

  @override
  int get offset => meta.page.offset;

  @override
  int get limit => meta.page.limit;

  @override
  int get total => meta.page.total;

  final ResponseMeta meta;

  @override
  List<FileResponseItem> get items => files;
}

@JsonSerializable()
class FileResponseItem {

  FileResponseItem({
    required this.id,
    required this.attributes,
    required this.relationships,
  });

  factory FileResponseItem.fromJson(Map<String, dynamic> json) =>
      _$FileResponseItemFromJson(json);
  final String id;
  final FileResponseItemAttributes attributes;
  final FileResponseItemRelationships relationships;
}

@JsonSerializable()
class FileResponseItemAttributes {

  FileResponseItemAttributes({
    required this.name,
    required this.description,
    required this.numberOfDownloads,
    required this.createdAt,
    required this.lastUpdatedAt,
    required this.mimeType,
    required this.isReadable,
    required this.isDownloadable,
  });

  factory FileResponseItemAttributes.fromJson(Map<String, dynamic> json) =>
      _$FileResponseItemAttributesFromJson(json);
  final String name;
  final String description;

  @JsonKey(name: 'downloads')
  final int numberOfDownloads;

  @JsonKey(name: 'mkdate')
  final String createdAt;

  @JsonKey(name: 'chdate')
  final String lastUpdatedAt;

  @JsonKey(name: 'mime-type')
  final String mimeType;

  @JsonKey(name: 'is-readable')
  final bool isReadable;

  @JsonKey(name: 'is-downloadable')
  final bool isDownloadable;
}

@JsonSerializable()
class FileResponseItemRelationships {

  FileResponseItemRelationships({required this.owner});

  factory FileResponseItemRelationships.fromJson(Map<String, dynamic> json) =>
      _$FileResponseItemRelationshipsFromJson(json);
  final FileResponseItemOwner owner;
}

@JsonSerializable()
class FileResponseItemOwner {

  FileResponseItemOwner({required this.meta});

  factory FileResponseItemOwner.fromJson(Map<String, dynamic> json) =>
      _$FileResponseItemOwnerFromJson(json);
  final FileResponseItemOwnerMeta meta;
}

@JsonSerializable()
class FileResponseItemOwnerMeta {

  FileResponseItemOwnerMeta({required this.name});

  factory FileResponseItemOwnerMeta.fromJson(Map<String, dynamic> json) =>
      _$FileResponseItemOwnerMetaFromJson(json);
  final String name;
}
