import 'package:json_annotation/json_annotation.dart';
import 'package:studip_api_client/studip_api_client.dart';

part 'folder_response.g.dart';

@JsonSerializable()
class FolderResponse implements ItemListResponse<FolderResponseItem> {
  @JsonKey(name: 'data')
  final List<FolderResponseItem> folders;

  FolderResponse({required this.folders, required this.meta});

  factory FolderResponse.fromJson(Map<String, dynamic> json) =>
      _$FolderResponseFromJson(json);

  @override
  int get offset => meta.page.offset;

  @override
  int get limit => meta.page.limit;

  @override
  int get total => meta.page.total;

  final ResponseMeta meta;

  @override
  List<FolderResponseItem> get items => folders;
}

@JsonSerializable()
class FolderResponseItem {
  final String id;
  final FolderResponseItemAttributes attributes;

  FolderResponseItem({required this.id, required this.attributes});

  factory FolderResponseItem.fromJson(Map<String, dynamic> json) =>
      _$FolderResponseItemFromJson(json);
}

@JsonSerializable()
class FolderResponseItemAttributes {
  @JsonKey(name: 'folder-type')
  final String folderType;
  final String name;
  final String? description;

  @JsonKey(name: 'mkdate')
  final String createdAt;

  @JsonKey(name: 'chdate')
  final String lastUpdatedAt;

  @JsonKey(name: 'is-visible')
  final bool isVisible;

  @JsonKey(name: 'is-readable')
  final bool isReadable;

  @JsonKey(name: 'is-writable')
  final bool isWritable;

  @JsonKey(name: 'is-subfolder-allowed')
  final bool isSubfolderAllowed;

  FolderResponseItemAttributes({
    required this.folderType,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.lastUpdatedAt,
    required this.isVisible,
    required this.isReadable,
    required this.isWritable,
    required this.isSubfolderAllowed,
  });

  factory FolderResponseItemAttributes.fromJson(Map<String, dynamic> json) =>
      _$FolderResponseItemAttributesFromJson(json);
}
