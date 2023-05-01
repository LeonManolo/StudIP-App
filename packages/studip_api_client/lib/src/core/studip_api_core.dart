import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:logger/logger.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'studip_oauth_client.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class StudIpAPICore {
  final String _baseUrl;
  final OAuth2Helper _oauth2Helper;
  final Dio _dio;
  final _apiBaseUrl = "jsonapi.php/v1";
  static final _defaultBaseUrl = "http://miezhaus.feste-ip.net:55109";

  StudIpAPICore({String? baseUrl, Dio? dio, OAuth2Helper? oauth2Helper})
      : _baseUrl = baseUrl ?? _defaultBaseUrl,
        _dio = dio ?? Dio(),
        _oauth2Helper = oauth2Helper ??
            OAuth2Helper(
              StudIpOAuth2Client(baseUrl: _defaultBaseUrl),
              clientId: "5",
              grantType: OAuth2Helper.authorizationCode,
              scopes: ["api"],
            );

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
        "$_baseUrl/$_apiBaseUrl/file-refs/$fileId/content", localStoragePath,
        options: Options(headers: {
          HttpHeaders.acceptHeader: "*/*",
          HttpHeaders.authorizationHeader: "Bearer $accessToken"
        }));

    return localStoragePath;
  }

  /// Checks whether File exists and isn't outdated. If [deleteOutdatedVersion] is set to true, outdated file versions are deleted.
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

  Future<String?> restoreUser() async {
    if ((await _oauth2Helper.getTokenFromStorage()) != null) {
      // Only if a token is present a automatic refresh should be tried (if needed)
      return await loginWithStudIp();
    } else {
      return null;
    }
  }

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
    } catch (e) {
      Logger().e(e, e);
      return null;
    }
  }

  Future<void> removeAllTokens() async {
    await _oauth2Helper.removeAllTokens();
  }
}
