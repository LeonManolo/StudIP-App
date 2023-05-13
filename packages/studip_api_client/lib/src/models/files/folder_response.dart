import 'package:studip_api_client/studip_api_client.dart';

class FolderListResponse implements ItemListResponse<FolderResponse> {
  final List<FolderResponse> folders;
  @override
  final int offset;
  @override
  final int limit;
  @override
  final int total;

  FolderListResponse({
    required this.folders,
    required this.offset,
    required this.limit,
    required this.total,
  });

  factory FolderListResponse.fromJson(Map<String, dynamic> json) {
    final page = json["meta"]["page"];
    List<dynamic> folders = json["data"];

    return FolderListResponse(
      folders: folders
          .map((rawFolder) => FolderResponse.fromJson(rawFolder))
          .toList(),
      offset: page["offset"],
      limit: page["limit"],
      total: page["total"],
    );
  }

  @override
  List<FolderResponse> get items => folders;
}

class FolderResponse {
  final String id;
  final String folderType;
  final String name;
  final String? description;
  final String createdAt;
  final String lastUpdatedAt;
  final bool isVisible;
  final bool isReadable;
  final bool isWritable;

  /// Whether user can create new subfolder within this folder
  final bool isSubfolderAllowed;

  FolderResponse({
    required this.id,
    required this.folderType,
    required this.name,
    this.description,
    required this.createdAt,
    required this.lastUpdatedAt,
    required this.isVisible,
    required this.isReadable,
    required this.isWritable,
    required this.isSubfolderAllowed,
  });

  factory FolderResponse.fromJson(Map<String, dynamic> json) {
    final attributes = json["attributes"];

    return FolderResponse(
      id: json["id"],
      folderType: attributes["folder-type"],
      name: attributes["name"],
      description: attributes["description"],
      createdAt: attributes["mkdate"],
      lastUpdatedAt: attributes["chdate"],
      isVisible: attributes["is-visible"],
      isReadable: attributes["is-readable"],
      isWritable: attributes['is-writable'],
      isSubfolderAllowed: attributes['is-subfolder-allowed'],
    );
  }
}
