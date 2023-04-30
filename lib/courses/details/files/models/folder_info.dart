import 'package:files_repository/files_repository.dart';

enum FolderType { root, normal }

class FolderInfo {
  final String displayName;
  final FolderType folderType;
  final Folder folder;

  FolderInfo({
    required this.displayName,
    required this.folderType,
    required this.folder,
  });

  factory FolderInfo.fromFolder({required Folder folder}) {
    return FolderInfo(
      displayName: folder.folderType == "RootFolder" ? "Root" : folder.name,
      folderType: folder.folderType == "RootFolder"
          ? FolderType.root
          : FolderType.normal,
      folder: folder,
    );
  }
}
