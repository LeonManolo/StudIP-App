import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:token_storage/token_storage.dart';

class SecureTokenStorage extends TokenStorage {
  final _storage = FlutterSecureStorage();
  static const String _SECURE_STORAGE_KEY = "my_secure_storage_key";

  @override
  Future<void> clearToken() async {
    await _storage.delete(key: _SECURE_STORAGE_KEY);
  }

  @override
  Future<String?> readToken() async {
    return await _storage.read(key: _SECURE_STORAGE_KEY);
  }

  @override
  Future<void> saveToken(String token) async {
    await _storage.write(key: _SECURE_STORAGE_KEY, value: token);
  }
}