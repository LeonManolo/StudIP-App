import 'dart:async';

abstract class StudIpFilesCore {
  /// Downloads a given file and returns the local storage path
  Future<String?> downloadFile({
    required String fileId,
    required String fileName,
    required List<String> parentFolderIds,
    required DateTime lastModified,
  });

  Future<void> uploadFiles({
    required String parentFolderId,
    required Iterable<String> localFilePaths,
  });

  /// Checks whether File exists and isn't outdated. If [deleteOutdatedVersion] is set to true, outdated file versions are deleted.
  Future<bool> isFilePresentAndUpToDate({
    required String fileId,
    required String fileName,
    required List<String> parentFolderIds,
    required DateTime lastModified,
    required bool deleteOutdatedVersion,
  });

  Future<String> localFilePath({
    required String? fileId,
    required String? fileName,
    required List<String> parentFolderIds,
  });

  /// This method can be used to automatically delete persisted data which was deleted in the backend
  FutureOr<void> cleanup({
    required List<String> parentFolderIds,
    required List<String> expectedIds,
  });
}
