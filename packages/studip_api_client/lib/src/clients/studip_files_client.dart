import 'dart:async';

import '../models/models.dart';

abstract class StudIPFilesClient {
  Future<FolderResponse> getCourseRootFolder({required String courseId});

  Future<FolderListResponse> getFolders({
    required String folderId,
    required int offset,
    required int limit,
  });

  Future<FileListResponse> getFiles({
    required String folderId,
    required int offset,
    required int limit,
  });

  Future<String?> downloadFile({
    required String fileId,
    required String fileName,
    required List<String> parentFolderIds,
    required DateTime lastModified,
  });

  Future<bool> isFilePresentAndUpToDate({
    required String fileId,
    required String fileName,
    required List<String> parentFolderIds,
    required DateTime lastModified,
    required bool deleteOutdatedVersion,
  });

  Future<String> localFilePath({
    required String fileId,
    required String fileName,
    required List<String> parentFolderIds,
  });

  FutureOr<void> cleanup({
    required List<String> parentFolderIds,
    required List<String> expectedIds,
  });
}
