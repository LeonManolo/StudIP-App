/// {@template token_storage}
/// Token storage for the authentication repository.
/// {@endtemplate}
abstract class TokenStorage {
  /// Returns the current token.
  Future<String?> readToken();

  /// Saves the current token.
  Future<void> saveToken(String token);

  /// Clears the current token.
  Future<void> clearToken();
}