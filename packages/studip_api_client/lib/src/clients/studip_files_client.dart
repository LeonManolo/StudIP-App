import 'dart:async';
import 'dart:convert';

import 'package:studip_api_client/src/core/interfaces/interfaces.dart';
import 'package:studip_api_client/src/core/studip_api_core.dart';
import 'package:studip_api_client/src/extensions/extensions.dart';

import '../models/models.dart';

abstract interface class StudIPFilesClient {
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

  FutureOr<void> uploadFiles({
    required String parentFolderId,
    required Iterable<String> localFilePaths,
  });

  FutureOr<void> createNewFolder({
    required String courseId,
    required String parentFolderId,
    required String folderName,
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

  Future<FileResponse> getFileRef({
    required String fileId,
  });

  FutureOr<void> cleanup({
    required List<String> parentFolderIds,
    required List<String> expectedIds,
  });
}

class StudIPFilesClientImpl implements StudIPFilesClient {
  final StudIpHttpCore _httpCore;
  final StudIpFilesCore _filesCore;

  StudIPFilesClientImpl({StudIpHttpCore? httpCore, StudIpFilesCore? filesCore})
      : _httpCore = httpCore ?? StudIpAPICore.shared,
        _filesCore = filesCore ?? StudIpAPICore.shared;

  @override
  Future<FolderResponse> getCourseRootFolder({required String courseId}) async {
    final response = await _httpCore
        .get(endpoint: "courses/$courseId/folders", queryParameters: {
      "page[limit]": "1",
    });

    final body = response.json();
    response.throwIfInvalidHttpStatus(body: body);

    return FolderListResponse.fromJson(body).folders.first;
  }

  @override
  Future<FileListResponse> getFiles(
      {required String folderId,
      required int offset,
      required int limit}) async {
    final response = await _httpCore
        .get(endpoint: "folders/$folderId/file-refs", queryParameters: {
      "page[offset]": "$offset",
      "page[limit]": "$limit",
    });

    final body = response.json();
    response.throwIfInvalidHttpStatus(body: body);

    return FileListResponse.fromJson(body);
  }

  @override
  Future<FolderListResponse> getFolders(
      {required String folderId,
      required int offset,
      required int limit}) async {
    final response = await _httpCore
        .get(endpoint: "folders/$folderId/folders", queryParameters: {
      "page[offset]": "$offset",
      "page[limit]": "$limit",
    });

    final body = response.json();
    response.throwIfInvalidHttpStatus(body: body);

    return FolderListResponse.fromJson(body);
  }

  @override
  Future<String?> downloadFile(
      {required String fileId,
      required String fileName,
      required List<String> parentFolderIds,
      required DateTime lastModified}) {
    return _filesCore.downloadFile(
        fileId: fileId,
        fileName: fileName,
        parentFolderIds: parentFolderIds,
        lastModified: lastModified);
  }

  @override
  FutureOr<void> uploadFiles({
    required String parentFolderId,
    required Iterable<String> localFilePaths,
  }) async {
    await _filesCore.uploadFiles(
      parentFolderId: parentFolderId,
      localFilePaths: localFilePaths,
    );
  }

  @override
  FutureOr<void> createNewFolder({
    required String courseId,
    required String parentFolderId,
    required String folderName,
  }) async {
    await _httpCore.post(
      endpoint: 'courses/$courseId/folders',
      jsonString: jsonEncode(
        {
          "data": {
            "type": "folders",
            "attributes": {"name": folderName},
            "relationships": {
              "parent": {
                "data": {"type": "folders", "id": parentFolderId}
              }
            }
          }
        },
      ),
    );
  }

  @override
  Future<bool> isFilePresentAndUpToDate({
    required String fileId,
    required String fileName,
    required List<String> parentFolderIds,
    required DateTime lastModified,
    bool deleteOutdatedVersion = true,
  }) {
    return _filesCore.isFilePresentAndUpToDate(
      fileId: fileId,
      fileName: fileName,
      parentFolderIds: parentFolderIds,
      lastModified: lastModified,
      deleteOutdatedVersion: deleteOutdatedVersion,
    );
  }

  @override
  Future<String> localFilePath(
      {required String fileId,
      required String fileName,
      required List<String> parentFolderIds}) async {
    return _filesCore.localFilePath(
        fileId: fileId, fileName: fileName, parentFolderIds: parentFolderIds);
  }

  @override
  Future<FileResponse> getFileRef({
    required String fileId,
  }) async {
    final response = await _httpCore.get(endpoint: "file-refs/$fileId");

    final body = response.json();
    response.throwIfInvalidHttpStatus(body: body);

    return FileResponse.fromJson(body["data"]);
  }

  @override
  FutureOr<void> cleanup(
      {required List<String> parentFolderIds,
      required List<String> expectedIds}) {
    return _filesCore.cleanup(
      parentFolderIds: parentFolderIds,
      expectedIds: expectedIds,
    );
  }
}
