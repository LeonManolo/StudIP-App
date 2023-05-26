import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oauth2_client/interfaces.dart';

class CustomTokenStorage implements BaseStorage {
  static const FlutterSecureStorage storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
      groupId: "G59VX2UW33.de.hsflensburg.studipadawan.sharedKeychain",
    ),
  );

  CustomTokenStorage();

  @override
  Future<String?> read(String key) async {
    return await storage.read(key: key);
  }

  @override
  Future<void> write(String key, String value) async {
    return await storage.write(key: key, value: value);
  }
}
