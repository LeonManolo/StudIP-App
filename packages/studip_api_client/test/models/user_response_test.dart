// ignore_for_file: prefer_const_constructors
// ignore_for_file: avoid_dynamic_calls

import 'package:studip_api_client/src/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('UserResponse', () {
    test('can be serialized', () {
      final Map<String, dynamic> rawUserResponse = {
        'data': {
          'id': 'id_123',
          'attributes': {
            'username': 'username123',
            'formatted-name': 'Test, User',
            'family-name': 'Test',
            'given-name': 'User',
            'permission': 'author',
            'email': 'test@user.com',
            'phone': '123456789',
            'homepage': 'test.com',
            'address': 'teststreet 2',
            'name-prefix': 'Dr.',
            'name-suffix': ''
          },
          'meta': {
            'avatar': {'medium': 'https://test.com/test.png'}
          }
        }
      };

      final userResponse = UserResponse.fromJson(rawUserResponse);
      final attributes = userResponse.userResponseItem.attributes;
      expect(
        rawUserResponse['data']['id'] as String,
        userResponse.userResponseItem.id,
      );
      expect(
        rawUserResponse['data']['attributes']['username'] as String,
        attributes.username,
      );
      expect(
        rawUserResponse['data']!['attributes']['formatted-name'] as String,
        attributes.formattedName,
      );
      expect(
        rawUserResponse['data']['attributes']['family-name'] as String,
        attributes.familyName,
      );
      expect(
        rawUserResponse['data']['attributes']['given-name'] as String,
        attributes.givenName,
      );
      expect(
        rawUserResponse['data']['attributes']['permission'] as String,
        attributes.permission,
      );
      expect(
        rawUserResponse['data']['attributes']['email'] as String,
        attributes.email,
      );
      expect(
        rawUserResponse['data']['attributes']['phone'] as String?,
        attributes.phone,
      );
      expect(
        rawUserResponse['data']['attributes']['homepage'] as String?,
        attributes.homepage,
      );
      expect(
        rawUserResponse['data']['attributes']['address'] as String?,
        attributes.address,
      );
      expect(
        rawUserResponse['data']['meta']['avatar']['medium'] as String,
        userResponse.userResponseItem.meta.avatar.mediumAvatarUrl,
      );
      expect(
        rawUserResponse['data']['attributes']['name-prefix'] as String,
        attributes.namePrefix,
      );
      expect(
        rawUserResponse['data']['attributes']['name-suffix'] as String,
        attributes.nameSuffix,
      );
    });
  });
}
