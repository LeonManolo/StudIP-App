import 'package:studip_api_client/src/core/interfaces/interfaces.dart';
import 'package:studip_api_client/src/core/studip_api_core.dart';

abstract interface class StudIPAuthenticationClient {
  Future<void> removeAllTokens();

  Future<String?> restoreUser();

  Future<String?> loginWithStudIp();
}

class StudIPAuthenticationClientImpl implements StudIPAuthenticationClient {

  StudIPAuthenticationClientImpl({StudIpAuthenticationCore? core})
      : _core = core ?? StudIpAPICore.shared;
  final StudIpAuthenticationCore _core;

  @override
  Future<void> removeAllTokens() async {
    await _core.removeAllTokens();
  }

  @override
  Future<String?> restoreUser() async {
    return await _core.restoreUser();
  }

  @override
  Future<String?> loginWithStudIp() async {
    return await _core.loginWithStudIp();
  }
}
