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
    required studip_api_client.FolderResponseItem folderResponseItem,
  }) {
    final studip_api_client.FolderResponseItemAttributes attributes =
        folderResponseItem.attributes;
    return Folder(
      id: folderResponseItem.id,
      folderType: attributes.folderType,
      name: attributes.name,
      createdAt: DateTime.parse(attributes.createdAt).toLocal(),
      lastUpdatedAt: DateTime.parse(attributes.lastUpdatedAt).toLocal(),
      isVisible: attributes.isVisible,
      isReadable: attributes.isReadable,
      isWritable: attributes.isWritable,
      isSubfolderAllowed: attributes.isSubfolderAllowed,
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
