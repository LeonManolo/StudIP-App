abstract interface class StudIpAuthenticationCore {
  Future<void> removeAllTokens();

  Future<String?> restoreUser();

  Future<String?> loginWithStudIp();
}
