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
    required DateTime lastModified,
  });

  Future<bool> isFilePresentAndUpToDate({
    required String fileId,
    required String fileName,
    required DateTime lastModified,
  });

  Future<String> localFilePath({
    required String fileId,
    required String fileName,
    required DateTime lastModified,
  });
}
