import 'dart:async';

import 'package:jwt_decode/jwt_decode.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:token_storage/token_storage.dart';

import 'models/models.dart';

class AuthenticationRepository {
  final TokenStorage _tokenStorage;
  final OAuth2Client _oAuth2Client;
  final TokenStorage _refreshTokenStorage;
  User _currentUser = User.empty;
  final StreamController<User> _controller = StreamController<User>();

  AuthenticationRepository({
    TokenStorage? accessTokenStorage,
    TokenStorage? refreshTokenStorage,
  })  : _tokenStorage = accessTokenStorage ?? SharedPrefsTokenStorage(),
        _refreshTokenStorage = refreshTokenStorage ?? SecureTokenStorage(),
        _oAuth2Client = StudIpOAuth2Client(
            redirectUri: 'de.hsflensburg.studipadawan://redirect',
            customUriScheme: 'de.hsflensburg.studipadawan') {
    _restoreUser();
  }

  Future<void> _restoreUser() async {
    final accessToken = await _tokenStorage.readToken();
    final refreshToken = await _refreshTokenStorage.readToken();
    if (accessToken != null && refreshToken != null) {
      final decodedToken = Jwt.parseJwt(accessToken);
      final userId = decodedToken["sub"];
      final user = User(userId);
      _currentUser = user;
      _controller.add(_currentUser);
    }
  }

  Future<void> loginWithStudIp() async {
    AccessTokenResponse tokenResponse = await _oAuth2Client
        .getTokenWithAuthCodeFlow(clientId: '5', scopes: ['api']);

    print(tokenResponse.accessToken);
    if (tokenResponse.httpStatusCode == 200) {
      await _tokenStorage.saveToken(tokenResponse.accessToken!);
      await _refreshTokenStorage.saveToken(tokenResponse.refreshToken!);
      Map<String, dynamic> decodedToken =
          Jwt.parseJwt(tokenResponse.accessToken!);
      String userId = decodedToken["sub"];
      print(userId);
      print("refresh_token: ${tokenResponse.refreshToken}");
      final user = User(userId);
      _controller.add(user);
      _currentUser = user;
    }
  }

  Stream<User> get user => _controller.stream;

  User get currentUser {
    return _currentUser;
  }

  Future<void> logOut() async {
    await _tokenStorage.clearToken();
    await _refreshTokenStorage.clearToken();
    _currentUser = User.empty;
    _controller.add(_currentUser);
  }
}
