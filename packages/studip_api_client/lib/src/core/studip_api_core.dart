import 'package:jwt_decode/jwt_decode.dart';
import 'package:logger/logger.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'studip_oauth_client.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class StudIpAPICore {
  final String _baseUrl;
  final OAuth2Helper _oauth2Helper;
  final _apiBaseUrl = "jsonapi.php/v1";
  static final _defaultBaseUrl = "http://miezhaus.feste-ip.net:55109";

  StudIpAPICore({String? baseUrl, oauth2Helper})
      : _baseUrl = baseUrl ?? _defaultBaseUrl,
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
