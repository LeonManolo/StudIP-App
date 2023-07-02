import 'dart:async';

import 'package:authentication_repository/src/models/models.dart';
import 'package:studip_api_client/studip_api_client.dart';

class AuthenticationRepository {
  AuthenticationRepository({required StudIPAuthenticationClient client})
      : _client = client {
    _restoreUser();
  }

  final StudIPAuthenticationClient _client;
  User _currentUser = User.empty;
  final StreamController<User> _controller = StreamController<User>();

  Future<void> loginWithStudIp() async {
    await _client.removeAllTokens();
    final userId = await _client.loginWithStudIp();

    if (userId != null) {
      final user = User(userId);
      _controller.add(user);
      _currentUser = user;
    }
  }

  Future<void> _restoreUser() async {
    final userId = await _client.restoreUser();

    if (userId != null) {
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
    await _client.removeAllTokens();
    _currentUser = User.empty;
    _controller.add(_currentUser);
  }
}
