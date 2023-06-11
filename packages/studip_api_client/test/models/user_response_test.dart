// ignore_for_file: prefer_const_constructors

import 'package:studip_api_client/src/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('UserResponse', () {
    test('can be serialized', () {
      final Map<String, dynamic> json = {
        "data": {
          "id": "id_123",
          "attributes": {
            "username": "username123",
            "formatted-name": "Test, User",
            "family-name": "Test",
            "given-name": "User",
            "permission": "author",
            "email": "test@user.com",
            "phone": "123456789",
            "homepage": "test.com",
            "address": "teststreet 2",
            "name-prefix": "Dr.",
            "name-suffix": ""
          },
          "meta": {
            "avatar": {
              "medium": "https://test.com/test.png"
            }
          }
        }
      };

      final userFromJson = UserResponse.fromJson(json);
      expect(json["data"]["id"] as String, userFromJson.id);
      expect(json["data"]["attributes"]["username"] as String, userFromJson.username);
      expect(json["data"]!["attributes"]["formatted-name"] as String, userFromJson.formattedName);
      expect(json["data"]["attributes"]["family-name"] as String, userFromJson.familyName);
      expect(json["data"]["attributes"]["given-name"] as String, userFromJson.givenName);
      expect(json["data"]["attributes"]["permission"] as String, userFromJson.permission);
      expect(json["data"]["attributes"]["email"] as String, userFromJson.email);
      expect(json["data"]["attributes"]["phone"] as String?, userFromJson.phone);
      expect(json["data"]["attributes"]["homepage"] as String?, userFromJson.homepage);
      expect(json["data"]["attributes"]["address"] as String?, userFromJson.address);
      expect(json["data"]["meta"]["avatar"]["medium"] as String, userFromJson.avatarUrl);
      expect(json["data"]["attributes"]["name-prefix"] as String, userFromJson.namePrefix);
      expect(json["data"]["attributes"]["name-suffix"] as String, userFromJson.nameSuffix);
    });
  });
}

