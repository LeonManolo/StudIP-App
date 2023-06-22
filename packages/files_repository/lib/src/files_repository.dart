import 'dart:async';

import 'package:files_repository/src/excpetions/exceptions.dart';
import 'package:files_repository/src/models/models.dart';
import 'package:studip_api_client/studip_api_client.dart';

class FilesRepository {
  const FilesRepository({required StudIPFilesClient apiClient})
      : _apiClient = apiClient;
  final StudIPFilesClient _apiClient;

  Future<List<Folder>> getAllVisibleFolders({
    required String parentFolderId,
  }) async {
    try {
      final List<FolderResponseItem> allFolders = await _getResponse(
        id: parentFolderId,
        loadItems: ({required id, required limit, required offset}) async {
          return _apiClient.getFolders(
            folderId: id,
            offset: offset,
            limit: limit,
          );
        },
      );

      return allFolders
          .where(
            (folderResponse) =>
                folderResponse.attributes.isVisible &&
                folderResponse.attributes.isReadable,
          )
          .map(
            (folderResponse) =>
                Folder.fromFolderResponse(folderResponseItem: folderResponse),
          )
          .toList();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<List<File>> getAllDownloadableFiles({
    required String parentFolderId,
  }) async {
    try {
      final List<FileResponse> allFiles = await _getResponse(
        id: parentFolderId,
        loadItems: ({required id, required limit, required offset}) async {
          return _apiClient.getFiles(
            folderId: id,
            offset: offset,
            limit: limit,
          );
        },
      );
      return allFiles
          .where(
            (fileResponse) =>
                fileResponse.isDownloadable && fileResponse.isReadable,
          )
          .map(
            (fileResponse) => File.fromFileResponse(fileResponse: fileResponse),
          )
          .toList();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<Folder> getCourseRootFolder({required String courseId}) async {
    try {
      final rootFolderResponse =
          await _apiClient.getCourseRootFolder(courseId: courseId);
      return Folder.fromFolderResponse(folderResponseItem: rootFolderResponse);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<String?> downloadFile({
    required File file,
    required List<String> parentFolderIds,
  }) {
    return _apiClient.downloadFile(
      fileId: file.id,
      fileName: file.name,
      parentFolderIds: parentFolderIds,
      lastModified: file.lastUpdatedAt,
    );
  }

  FutureOr<void> uploadFiles({
    required String parentFolderId,
    required Iterable<String> localFilePaths,
  }) async {
    try {
      await _apiClient.uploadFiles(
        parentFolderId: parentFolderId,
        localFilePaths: localFilePaths,
      );
    } on UploadFilesCoreFailure catch (failure) {
      throw UploadFilesFailure.fromUploadFilesCoreFailure(failure: failure);
    }
  }

  FutureOr<void> createNewFolder({
    required String courseId,
    required String parentFolderId,
    required String folderName,
  }) async {
    await _apiClient.createNewFolder(
      courseId: courseId,
      parentFolderId: parentFolderId,
      folderName: folderName,
    );
  }

  Future<bool> isFilePresentAndUpToDate({
    required File file,
    required List<String> parentFolderIds,
  }) async {
    return _apiClient.isFilePresentAndUpToDate(
      fileId: file.id,
      fileName: file.name,
      parentFolderIds: parentFolderIds,
      lastModified: file.lastUpdatedAt,
      deleteOutdatedVersion: true,
    );
  }

  Future<String> localFilePath({
    required File file,
    required List<String> parentFolderIds,
  }) {
    return _apiClient.localFilePath(
      fileId: file.id,
      fileName: file.name,
      parentFolderIds: parentFolderIds,
    );
  }

  FutureOr<void> cleanup({
    required List<String> parentFolderIds,
    required List<String> expectedIds,
  }) {
    return _apiClient.cleanup(
      parentFolderIds: parentFolderIds,
      expectedIds: expectedIds,
    );
  }

  // ***** Private Helpers *****

  /// This method can be used to recursively fetch all items.
  Future<List<I>> _getResponse<I>({
    required String id,
    int limit = 30,
    int offset = 0,
    required Future<ItemListResponse<I>> Function({
      required String id,
      required int limit,
      required int offset,
    }) loadItems,
  }) async {
    final response = await loadItems(id: id, limit: limit, offset: offset);
    if (response.total > limit && (response.offset + limit) < response.total) {
      final itemsResponse = response.items;
      return itemsResponse
        ..addAll(
          await _getResponse(
            id: id,
            limit: limit,
            offset: offset + limit,
            loadItems: loadItems,
          ),
        );
    } else {
      return response.items;
    }
  }
}
