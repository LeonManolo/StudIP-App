import 'package:shared_preferences/shared_preferences.dart';
import 'package:token_storage/token_storage.dart';

/// {@template in_memory_token_storage}
/// In-memory token storage for the authentication client.
/// {@endtemplate}
class SharedPrefsTokenStorage implements TokenStorage {
  static const String _SHARED_PREF_KEY = "shared_prefs_token_storage_key";

  @override
  Future<String?> readToken() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString(_SHARED_PREF_KEY);
  }

  @override
  Future<void> saveToken(String token) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString(_SHARED_PREF_KEY, token);
  }

  @override
  Future<void> clearToken() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.remove(_SHARED_PREF_KEY);
  }
}