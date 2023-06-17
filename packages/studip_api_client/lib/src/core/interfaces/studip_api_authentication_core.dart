abstract class StudIpAPIAuthenticationCore {
  Future<void> removeAllTokens();

  Future<String?> restoreUser();

  Future<String?> loginWithStudIp();
}
