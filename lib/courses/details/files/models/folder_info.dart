import 'package:courses_repository/courses_repository.dart';

import 'folder_type.dart';

class FolderInfo {
  final String displayName;
  final FolderType folderType;
  final Folder folder;

  FolderInfo({
    required this.displayName,
    required this.folderType,
    required this.folder,
  });
}
