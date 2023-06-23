// ignore_for_file: prefer_const_constructors
import 'package:mocktail/mocktail.dart';
import 'package:studip_api_client/studip_api_client.dart';
import 'package:test/test.dart';
import 'package:user_repository/src/user_repository.dart';

class MockStudIPUserClient extends Mock implements StudIPUserClient {}

void main() {
  group('UserRepository', () {
    late MockStudIPUserClient studIPUserClient;
    late UserRepository sut;

    setUp(() {
      studIPUserClient = MockStudIPUserClient();
      sut = UserRepository(
        studIpApiClient: studIPUserClient,
      );
    });

    group('getCurrentUser', () {
      test('throws when getCurrentUser (api client) fails', () async {
        final exception = Exception('oops');
        when(() => studIPUserClient.getCurrentUser()).thenThrow(exception);
        expect(
          () async => sut.getCurrentUser(),
          throwsA(exception),
        );
      });

      test('throws when getCurrentUser (repository) fails', () async {
        final exception = Exception('oops');
        when(
          () => studIPUserClient.getCurrentUser(),
        ).thenThrow(exception);
        expect(
          () async => sut.getCurrentUser(),
          throwsA(exception),
        );
      });

      test('returns correct user on success', () async {
        final userResponse =
            UserResponse(userResponseItem: generateUserResponseItem(id: '123'));
        when(
          () => studIPUserClient.getCurrentUser(),
        ).thenAnswer((_) async => userResponse);

        final actual = await sut.getCurrentUser();

        expect(
          actual.userResponseItem.id,
          generateUserResponseItem(id: '123').id,
        );
      });
    });

    group('getUsers', () {
      const userSearchKeyword = 'ha';
      test('calls getUsers correctly', () async {
        try {
          await studIPUserClient.getUsers(userSearchKeyword);
        } catch (_) {}
        verify(() => studIPUserClient.getUsers(userSearchKeyword)).called(1);
      });

      test('throws when getUsers (api client) fails', () async {
        final exception = Exception('oops');
        when(() => studIPUserClient.getUsers(any())).thenThrow(exception);
        expect(
          () async => sut.getUsers(userSearchKeyword),
          throwsA(exception),
        );
      });

      test('returns correct users on success', () async {
        final userListResponse = UserListResponse(
          userResponseItems: [
            generateUserResponseItem(id: '1'),
            generateUserResponseItem(id: '2'),
          ],
        );
        when(() => studIPUserClient.getUsers(any())).thenAnswer(
          (_) async => userListResponse,
        );

        final actual = await sut.getUsers('');

        expect(
          actual.userResponseItems.map((user) => user.id).toSet(),
          {'userId_1', 'userId_2'},
        );
      });

      test('returns correct users according to search', () async {
        final users = [
          generateUserResponseItem(id: '1', username: 'hallo'),
          generateUserResponseItem(id: '2', username: 'peter'),
          generateUserResponseItem(id: '3', username: 'hamburg'),
        ];
        when(() => studIPUserClient.getUsers(any()))
            .thenAnswer((invocation) async {
          final search = invocation.positionalArguments[0] as String;
          return UserListResponse(
            userResponseItems: users
                .where(
                  (user) => user.attributes.username
                      .toLowerCase()
                      .contains(search.toLowerCase()),
                )
                .toList(),
          );
        });

        final actual = await sut.getUsers('ha');

        expect(
          actual.userResponseItems.map((user) => user.id).toSet(),
          {users[0].id, users[2].id},
        );
      });
    });
  });
}

UserResponseItem generateUserResponseItem({
  required String id,
  String? username,
  String? formattedName,
  String? familyName,
  String? givenName,
  String? permission,
  String? email,
  String? phone,
  String? homepage,
  String? address,
  String? avatarUrl,
  String? namePrefix,
  String? nameSuffix,
}) {
  return UserResponseItem(
    id: 'userId_$id',
    attributes: UserResponseItemAttributes(
      username: username ?? 'username_$id',
      formattedName: formattedName ?? 'formattedName_$id',
      familyName: familyName ?? 'familyName_$id',
      givenName: givenName ?? 'givenName_$id',
      permission: permission ?? 'author_$id',
      email: email ?? '$id@test.com',
      phone: phone ?? '+123456789',
      homepage: homepage ?? 'www.$id.com',
      address: address ?? 'address_$id',
      namePrefix: nameSuffix ?? '',
      nameSuffix: namePrefix ?? '',
    ),
    meta: UserResponseItemMeta(
      avatar: UserResponseItemMetaAvatar(
        smallAvatarUrl: avatarUrl ?? 'avatarUrl_small_$id',
        mediumAvatarUrl: avatarUrl ?? 'avatarUrl_medium_$id',
        normalAvatarUrl: avatarUrl ?? 'avatarUrl_normal_$id',
        originalAvatarUrl: avatarUrl ?? 'avatarUrl_original_$id',
      ),
    ),
  );
}
