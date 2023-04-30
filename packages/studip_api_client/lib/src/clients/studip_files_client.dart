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
    required String localFilePath,
  });
}
