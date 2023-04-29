class FolderListResponse {
  final List<FolderResponse> folders;
  final int offset;
  final int limit;
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

  FolderResponse({
    required this.id,
    required this.folderType,
    required this.name,
    this.description,
    required this.createdAt,
    required this.lastUpdatedAt,
    required this.isVisible,
    required this.isReadable,
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
    );
  }
}
