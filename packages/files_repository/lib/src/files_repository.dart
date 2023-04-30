import 'models/models.dart';
import 'package:studip_api_client/studip_api_client.dart';

class FilesRepository {
  final StudIPFilesClient _apiClient;

  const FilesRepository({required StudIPFilesClient apiClient})
      : _apiClient = apiClient;

  Future<List<Folder>> getAllVisibleFolders(
      {required String parentFolderId}) async {
    try {
      final List<FolderResponse> allFolders = await _getResponse(
          id: parentFolderId,
          loadItems: ({required id, required limit, required offset}) async {
            return _apiClient.getFolders(
                folderId: id, offset: offset, limit: limit);
          });

      return allFolders
          .where((folderResponse) =>
              folderResponse.isVisible && folderResponse.isReadable)
          .map((folderResponse) =>
              Folder.fromFolderResponse(folderResponse: folderResponse))
          .toList();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<List<File>> getAllFiles({required String parentFolderId}) async {
    try {
      final List<FileResponse> allFiles = await _getResponse(
          id: parentFolderId,
          loadItems: ({required id, required limit, required offset}) async {
            return _apiClient.getFiles(
                folderId: id, offset: offset, limit: limit);
          });
      return allFiles
          .map((fileResponse) =>
              File.fromFileResponse(fileResponse: fileResponse))
          .toList();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<Folder> getCourseRootFolder({required String courseId}) async {
    try {
      final rootFolderResponse =
          await _apiClient.getCourseRootFolder(courseId: courseId);
      return Folder.fromFolderResponse(folderResponse: rootFolderResponse);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<String?> downloadFile({required File file}) {
    return _apiClient.downloadFile(
      fileId: file.id,
      fileName: file.name,
      lastModified: file.lastUpdatedAt,
    );
  }

  Future<bool> isFilePresentAndUpToDate({required File file}) async {
    return await _apiClient.isFilePresentAndUpToDate(
      fileId: file.id,
      fileName: file.name,
      lastModified: file.lastUpdatedAt,
    );
  }

  Future<String> localFilePath({required File file}) {
    return _apiClient.localFilePath(
        fileId: file.id, fileName: file.name, lastModified: file.lastUpdatedAt);
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
    })
        loadItems,
  }) async {
    final response = await loadItems(id: id, limit: limit, offset: offset);
    if (response.total > limit && (response.offset + limit) < response.total) {
      var itemsResponse = response.items;
      itemsResponse.addAll(await _getResponse(
        id: id,
        limit: limit,
        offset: offset + limit,
        loadItems: loadItems,
      ));
      return itemsResponse;
    } else {
      return response.items;
    }
  }
}
