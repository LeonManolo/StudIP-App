import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:logger/logger.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/oauth2_exception.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:studip_api_client/src/core/custom_token_storage.dart';
import 'package:studip_api_client/src/core/interfaces/interfaces.dart';
import 'package:studip_api_client/src/exceptions.dart';
import 'studip_oauth_client.dart';
import 'package:http_forked/http.dart' as http;
import 'dart:io';

class StudIpAPICore
    implements
        StudIpAPIAuthenticationCore,
        StudIpAPIHttpCore,
        StudIpAPIFilesCore {
  static final shared = StudIpAPICore();

  final String _baseUrl;
  final OAuth2Helper _oauth2Helper;
  final Dio _dio;
  final _apiBaseUrl = "jsonapi.php/v1";
  static final _defaultBaseUrl = "http://studip.miezhaus.net";

  StudIpAPICore({String? baseUrl, Dio? dio, OAuth2Helper? oauth2Helper})
      : _baseUrl = baseUrl ?? _defaultBaseUrl,
        _dio = dio ?? Dio(),
        _oauth2Helper = oauth2Helper ??
            OAuth2Helper(
              StudIpOAuth2Client(baseUrl: _defaultBaseUrl),
              clientId: "5",
              grantType: OAuth2Helper.authorizationCode,
              scopes: ["api"],
              tokenBaseStorage: CustomTokenStorage(),
            );

  @override
  Future<http.Response> get({
    required String endpoint,
    Map<String, String>? queryParameters,
  }) async {
    final uri = Uri.parse("$_baseUrl/$_apiBaseUrl/$endpoint")
        .replace(queryParameters: queryParameters);

    return await _oauth2Helper.get(uri.toString(), headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.acceptHeader: "*/*"
    });
  }

  @override
  Future<http.Response> delete({
    required String endpoint,
    Map<String, String>? queryParameters,
  }) async {
    final uri = Uri.parse("$_baseUrl/$_apiBaseUrl/$endpoint")
        .replace(queryParameters: queryParameters);

    return await _oauth2Helper.delete(uri.toString(), headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.acceptHeader: "*/*"
    });
  }

  @override
  Future<http.Response> patch(
      {required String endpoint,
      Map<String, String>? bodyParameters,
      String? jsonString}) async {
    final uri = Uri.parse("$_baseUrl/$_apiBaseUrl/$endpoint");

    return await _oauth2Helper.patch(uri.toString(),
        headers: {
          HttpHeaders.contentTypeHeader: "application/vnd.api+json",
          HttpHeaders.acceptHeader: "*/*"
        },
        body: jsonString ?? jsonEncode(bodyParameters));
  }

  @override
  Future<http.Response> post(
      {required String endpoint,
      Map<String, String>? bodyParameters,
      String? jsonString}) async {
    final uri = Uri.parse("$_baseUrl/$_apiBaseUrl/$endpoint");

    return await _oauth2Helper.post(uri.toString(),
        headers: {
          HttpHeaders.contentTypeHeader: "application/vnd.api+json",
          HttpHeaders.acceptHeader: "*/*"
        },
        body: jsonString ?? jsonEncode(bodyParameters));
  }

  /// Downloads a given file and returns the local storage path
  @override
  Future<String?> downloadFile({
    required String fileId,
    required String fileName,
    required List<String> parentFolderIds,
    required DateTime lastModified,
  }) async {
    final localStoragePath = await localFilePath(
      fileId: fileId,
      fileName: fileName,
      parentFolderIds: parentFolderIds,
    );

    final accessToken =
        (await _oauth2Helper.getTokenFromStorage())?.accessToken;
    if (accessToken == null) {
      return null;
    }

    await _dio.download(
      "$_baseUrl/$_apiBaseUrl/file-refs/$fileId/content",
      localStoragePath,
      options: Options(
        headers: {
          HttpHeaders.acceptHeader: "*/*",
          HttpHeaders.authorizationHeader: "Bearer $accessToken"
        },
      ),
    );

    return localStoragePath;
  }

  /// Uploads all files passed in [localFilePaths]. If upload fails it throws an error.
  @override
  Future<void> uploadFiles({
    required String parentFolderId,
    required Iterable<String> localFilePaths,
  }) async {
    try {
      final accessToken =
          (await _oauth2Helper.getTokenFromStorage())?.accessToken;
      if (accessToken == null) {
        throw UploadFilesCoreFailure(message: 'Kein Access Token vorhanden');
      }

      final formDataFutures = localFilePaths.map(
        (localFilePath) async => FormData.fromMap(
          {
            'file': await MultipartFile.fromFile(localFilePath,
                contentType: MediaType('multipart', 'form-data'))
          },
        ),
      );

      final List<FormData> formDataElements =
          await Future.wait(formDataFutures);

      final Iterable<Future<Response<dynamic>>> fileUploadPostFutures =
          formDataElements.map(
        (formData) async => await _dio.post(
          '$_baseUrl/$_apiBaseUrl/folders/$parentFolderId/file-refs',
          data: formData,
          options: Options(
            headers: {
              HttpHeaders.acceptHeader: "*/*",
              HttpHeaders.authorizationHeader: "Bearer $accessToken"
            },
          ),
        ),
      );

      final responses = await Future.wait(fileUploadPostFutures);

      if (responses.any((response) => response.statusCode != 201)) {
        throw UploadFilesCoreFailure(
            message: 'Es konnten nicht alle Dateien hochgeladen werden');
      }
    } on UploadFilesCoreFailure {
      rethrow;
    } catch (err) {
      Logger().e(err);
      throw UploadFilesCoreFailure(
          message: 'Beim Hochladen ist ein Fehler aufgetreten.');
    }
  }

  /// Checks whether File exists and isn't outdated. If [deleteOutdatedVersion] is set to true, outdated file versions are deleted.
  @override
  Future<bool> isFilePresentAndUpToDate({
    required String fileId,
    required String fileName,
    required List<String> parentFolderIds,
    required DateTime lastModified,
    required bool deleteOutdatedVersion,
  }) async {
    final localStoragePath = await localFilePath(
        fileId: fileId, fileName: fileName, parentFolderIds: parentFolderIds);

    var file = File(localStoragePath);
    if (file.existsSync() && file.lastModifiedSync().isAfter(lastModified)) {
      // file was already downloaded and is up to date
      return true;
    } else if (file.existsSync() && deleteOutdatedVersion) {
      // Remove all old versions of the file (even if fileName and/or content changes,
      // the fileId stays the same -> therefore file.exsistsSync() should be true)
      file.parent.deleteSync(recursive: true);
    }
    return false;
  }

  @override
  Future<String> localFilePath({
    required String? fileId,
    required String? fileName,
    required List<String> parentFolderIds,
  }) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    if (fileId != null && fileName != null) {
      return "${documentsDirectory.path}/studipadawan/${parentFolderIds.join('/')}/$fileId/$fileName";
    } else {
      return "${documentsDirectory.path}/studipadawan/${parentFolderIds.join('/')}";
    }
  }

  /// This method can be used to automatically delete persisted data which was deleted in the backend
  @override
  FutureOr<void> cleanup({
    required List<String> parentFolderIds,
    required List<String> expectedIds,
  }) async {
    String localFolderPath = await localFilePath(
      fileId: null,
      fileName: null,
      parentFolderIds: parentFolderIds,
    );

    if (!Directory(localFolderPath).existsSync()) {
      // Directory isn't present (no files were downloaded for this directory so far)
      Logger().d("Directory $localFolderPath not present.");
      return;
    }

    try {
      Directory(localFolderPath).listSync().forEach((fileSystemEntity) {
        if (!expectedIds.any((id) => fileSystemEntity.path.contains(id))) {
          // ressource can be deleted, because it's not present in expectedIds
          fileSystemEntity.deleteSync(recursive: true);
        }
      });
    } catch (e) {
      Logger().e(e);
    }
  }

  // ***** AUTHENTICATION *****
  @override
  Future<String?> restoreUser() async {
    if ((await _oauth2Helper.getTokenFromStorage()) != null) {
      // Only if a token is present a automatic refresh should be tried (if needed)
      return await loginWithStudIp();
    } else {
      return null;
    }
  }

  @override
  Future<String?> loginWithStudIp() async {
    try {
      AccessTokenResponse? tokenResponse = await _oauth2Helper.getToken();
      final String? accessToken = tokenResponse?.accessToken;
      Logger().d("Access Token: $accessToken");
      if (tokenResponse?.httpStatusCode != 200 || accessToken == null) {
        return null;
      }
      Map<String, dynamic> decodedToken = Jwt.parseJwt(accessToken);
      String userId = decodedToken["sub"];
      return userId;
    } on OAuth2Exception catch (oAuthException) {
      Logger().e(oAuthException.error, oAuthException);
      removeAllTokens();
      return null;
    } catch (e) {
      Logger().e(e);
      removeAllTokens();
      return null;
    }
  }

  @override
  Future<void> removeAllTokens() async {
    await _oauth2Helper.removeAllTokens();
  }
}
