import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oauth2_client/interfaces.dart';

class CustomTokenStorage implements BaseStorage {
  CustomTokenStorage();
  static const FlutterSecureStorage storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
      groupId: 'N9XSF4AL84.de.hs-flensburg.studipadawan.sharedKeychain',
    ),
  );

  @override
  Future<String?> read(String key) async {
    return storage.read(key: key);
  }

  @override
  Future<void> write(String key, String value) async {
    return storage.write(key: key, value: value);
  }
}
