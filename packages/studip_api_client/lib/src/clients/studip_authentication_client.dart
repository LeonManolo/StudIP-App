abstract class StudIPAuthenticationClient {
  Future<void> removeAllTokens();

  Future<String?> restoreUser();

  Future<String?> loginWithStudIp();
}
