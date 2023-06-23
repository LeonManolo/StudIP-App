import 'package:json_annotation/json_annotation.dart';
import 'package:studip_api_client/studip_api_client.dart';

part 'folder_response.g.dart';

@JsonSerializable()
class FolderListResponse implements ItemListResponse<FolderResponseItem> {

  FolderListResponse({required this.folders, required this.meta});

  factory FolderListResponse.fromJson(Map<String, dynamic> json) =>
      _$FolderListResponseFromJson(json);
  @JsonKey(name: 'data')
  final List<FolderResponseItem> folders;

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

  FolderResponseItem({required this.id, required this.attributes});

  factory FolderResponseItem.fromJson(Map<String, dynamic> json) =>
      _$FolderResponseItemFromJson(json);
  final String id;
  final FolderResponseItemAttributes attributes;
}

@JsonSerializable()
class FolderResponseItemAttributes {

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
}
