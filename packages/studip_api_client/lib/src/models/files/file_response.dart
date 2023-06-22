import 'package:json_annotation/json_annotation.dart';
import 'package:studip_api_client/studip_api_client.dart';

part 'file_response.g.dart';

@JsonSerializable()
class FileResponse implements ItemListResponse<FileResponseItem> {
  @JsonKey(name: 'data')
  final List<FileResponseItem> files;

  FileResponse({required this.files, required this.meta});

  @override
  int get offset => meta.page.offset;

  @override
  int get limit => meta.page.limit;

  @override
  int get total => meta.page.total;

  final ResponseMeta meta;

  @override
  List<FileResponseItem> get items => files;

  factory FileResponse.fromJson(Map<String, dynamic> json) =>
      _$FileResponseFromJson(json);
}

@JsonSerializable()
class FileResponseItem {
  final String id;
  final FileResponseItemAttributes attributes;
  final FileResponseItemRelationships relationships;

  FileResponseItem({
    required this.id,
    required this.attributes,
    required this.relationships,
  });

  factory FileResponseItem.fromJson(Map<String, dynamic> json) =>
      _$FileResponseItemFromJson(json);
}

@JsonSerializable()
class FileResponseItemAttributes {
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
}

@JsonSerializable()
class FileResponseItemRelationships {
  final FileResponseItemOwner owner;

  FileResponseItemRelationships({required this.owner});

  factory FileResponseItemRelationships.fromJson(Map<String, dynamic> json) =>
      _$FileResponseItemRelationshipsFromJson(json);
}

@JsonSerializable()
class FileResponseItemOwner {
  final FileResponseItemOwnerMeta meta;

  FileResponseItemOwner({required this.meta});

  factory FileResponseItemOwner.fromJson(Map<String, dynamic> json) =>
      _$FileResponseItemOwnerFromJson(json);
}

@JsonSerializable()
class FileResponseItemOwnerMeta {
  final String name;

  factory FileResponseItemOwnerMeta.fromJson(Map<String, dynamic> json) =>
      _$FileResponseItemOwnerMetaFromJson(json);

  FileResponseItemOwnerMeta({required this.name});
}
