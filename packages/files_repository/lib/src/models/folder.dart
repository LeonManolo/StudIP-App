import 'package:studip_api_client/studip_api_client.dart' as studip_api_client;

class Folder {
  Folder({
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

  factory Folder.fromFolderResponse({
    required studip_api_client.FolderResponse folderResponse,
  }) {
    return Folder(
      id: folderResponse.id,
      folderType: folderResponse.folderType,
      name: folderResponse.name,
      createdAt: DateTime.parse(folderResponse.createdAt).toLocal(),
      lastUpdatedAt: DateTime.parse(folderResponse.lastUpdatedAt).toLocal(),
      isVisible: folderResponse.isVisible,
      isReadable: folderResponse.isReadable,
      isWritable: folderResponse.isWritable,
      isSubfolderAllowed: folderResponse.isSubfolderAllowed,
    );
  }
  final String id;
  final String folderType;
  final String name;
  final String? description;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;
  final bool isVisible;
  final bool isReadable;
  final bool isWritable;
  final bool isSubfolderAllowed;
}
