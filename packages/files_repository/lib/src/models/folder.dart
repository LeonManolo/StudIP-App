import 'package:studip_api_client/src/models/models.dart' as APIModels;

class Folder {
  final String id;
  final String folderType;
  final String name;
  final String? description;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;
  final bool isVisible;
  final bool isReadable;

  Folder({
    required this.id,
    required this.folderType,
    required this.name,
    this.description,
    required this.createdAt,
    required this.lastUpdatedAt,
    required this.isVisible,
    required this.isReadable,
  });

  factory Folder.fromFolderResponse(
      {required APIModels.FolderResponse folderResponse}) {
    return Folder(
      id: folderResponse.id,
      folderType: folderResponse.folderType,
      name: folderResponse.name,
      createdAt: DateTime.parse(folderResponse.createdAt).toLocal(),
      lastUpdatedAt: DateTime.parse(folderResponse.lastUpdatedAt).toLocal(),
      isVisible: folderResponse.isVisible,
      isReadable: folderResponse.isReadable,
    );
  }
}
