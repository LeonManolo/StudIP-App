import 'dart:async';

import 'package:studip_api_client/studip_api_client.dart';

import 'models/models.dart';

class AuthenticationRepository {
  final StudIPAuthenticationClient _client;
  User _currentUser = User.empty;
  final StreamController<User> _controller = StreamController<User>();

  AuthenticationRepository({required StudIPAuthenticationClient client})
      : _client = client {
    _restoreUser();
  }

  Future<void> loginWithStudIp() async {
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
    _client.removeAllTokens();
    _currentUser = User.empty;
    _controller.add(_currentUser);
  }
}
