// ignore_for_file: prefer_const_constructors
import 'package:mocktail/mocktail.dart';
import 'package:studip_api_client/studip_api_client.dart';
import 'package:test/test.dart';
import 'package:user_repository/src/user_repository.dart';

class MockStudIPUserClient extends Mock implements StudIPUserClient {}

class MockUserResponse extends Mock implements UserResponse {}

class MockUserListResponse extends Mock implements UserListResponse {}

void main() {
  group('UserRepository', () {
    late MockStudIPUserClient studIPUserClient;
    late UserRepository userRepository;

    setUp(() {
      studIPUserClient = MockStudIPUserClient();
      userRepository = UserRepository(
        studIpApiClient: studIPUserClient,
      );
    });

    group('getCurrentUser', () {
      test('throws when getCurrentUser (api client) fails', () async {
        final exception = Exception('oops');
        when(() => studIPUserClient.getCurrentUser()).thenThrow(exception);
        expect(
          () async => userRepository.getCurrentUser(),
          throwsA(exception),
        );
      });

      test('throws when getCurrentUser (repository) fails', () async {
        final exception = Exception('oops');
        when(
          () => studIPUserClient.getCurrentUser(),
        ).thenThrow(exception);
        expect(
          () async => userRepository.getCurrentUser(),
          throwsA(exception),
        );
      });

      test('returns correct user on success', () async {
        final userResponse = generateUserResponse(id: '123');
        when(
          () => studIPUserClient.getCurrentUser(),
        ).thenAnswer((_) async => userResponse);
        final actual = await userRepository.getCurrentUser();
        expect(
          actual.id,
          generateUserResponse(id: '123').id,
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
          () async => userRepository.getUsers(userSearchKeyword),
          throwsA(exception),
        );
      });

      test('returns correct users on success', () async {
        final userResponse = MockUserListResponse();
        when(() => userResponse.userResponses).thenReturn([
          generateUserResponse(id: '1'),
          generateUserResponse(id: '2'),
        ]);
        when(() => studIPUserClient.getUsers(any())).thenAnswer(
          (_) async => userResponse,
        );
        final actual = await userRepository.getUsers('');
        expect(
          actual.userResponses.map((user) => user.id).toSet(),
          {'userId_1', 'userId_2'},
        );
      });

      test('returns correct users according to search', () async {
        final users = [
          generateUserResponse(id: '1', username: 'hallo'),
          generateUserResponse(id: '2', username: 'peter'),
          generateUserResponse(id: '3', username: 'hamburg'),
        ];
        when(() => studIPUserClient.getUsers(any()))
            .thenAnswer((invocation) async {
          final search = invocation.positionalArguments[0] as String;
          return UserListResponse(
            userResponses: users
                .where((user) =>
                    user.username.toLowerCase().contains(search.toLowerCase()),)
                .toList(),
          );
        });
        final actual = await userRepository.getUsers('ha');
        expect(
          actual.userResponses.map((user) => user.id).toSet(),
          {users[0].id, users[2].id},
        );
      });
    });
  });
}

UserResponse generateUserResponse({
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
  return UserResponse(
    id: 'userId_$id',
    username: username ?? 'username_$id',
    formattedName: formattedName ?? 'formattedName_$id',
    familyName: familyName ?? 'familyName_$id',
    givenName: givenName ?? 'givenName_$id',
    permission: permission ?? 'author_$id',
    email: email ?? '$id@test.com',
    phone: phone ?? '+123456789',
    homepage: homepage ?? 'www.$id.com',
    address: address ?? 'address_$id',
    avatarUrl: avatarUrl ?? 'avatarUrl_$id',
    namePrefix: nameSuffix ?? '',
    nameSuffix: namePrefix ?? '',
  );
}
