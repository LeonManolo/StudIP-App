import 'package:bloc_test/bloc_test.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studip_api_client/studip_api_client.dart';
import 'package:studipadawan/app/bloc/app_bloc.dart';
import 'package:studipadawan/home/profile/bloc/profile_bloc.dart';
import 'package:studipadawan/home/profile/view/profile_page.dart';
import 'package:studipadawan/home/profile/widgets/optional_profile_attribute.dart';
import 'package:studipadawan/home/profile/widgets/profile_log_out_button.dart';
import 'package:studipadawan/home/profile/widgets/profile_page_body.dart';
import 'package:studipadawan/utils/loading_indicator.dart';
import 'package:studipadawan/utils/widgets/error_view/error_view.dart';
import 'package:user_repository/user_repository.dart';

class MockProfileBloc extends MockBloc<ProfileEvent, ProfileState>
    implements ProfileBloc {}

class MockUserRepository extends Mock implements UserRepository {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  group('ProfilePage', () {
    late UserRepository userRepository;

    setUp(() {
      userRepository = MockUserRepository();
    });

    testWidgets('renders ProfileView', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: userRepository,
          child: const MaterialApp(
            home: ProfilePage(),
          ),
        ),
      );

      expect(find.byType(ProfileView), findsOneWidget);
    });
  });

  group('ProfileView', () {
    late ProfileBloc profileBloc;
    late AppBloc appBloc;

    setUp(() {
      profileBloc = MockProfileBloc();
      appBloc = MockAppBloc();
    });

    testWidgets('renders LoadingIndicator for ProfileLoading', (tester) async {
      when(() => profileBloc.state).thenReturn(
        const ProfileLoading(),
      );
      await tester.pumpWidget(
        BlocProvider.value(
          value: profileBloc,
          child: const MaterialApp(home: ProfileView()),
        ),
      );
      expect(find.byType(LoadingIndicator), findsOneWidget);
    });

    testWidgets('renders ProfilePageBody for ProfilePopulated', (tester) async {
      when(() => profileBloc.state).thenReturn(
        ProfilePopulated(
          user: _generateUserResponseItem(),
        ),
      );
      await tester.pumpWidget(
        BlocProvider.value(
          value: profileBloc,
          child: const MaterialApp(home: ProfileView()),
        ),
      );
      expect(find.byType(ProfilePageBody), findsOneWidget);
    });

    testWidgets('renders ErrorView for ProfileFailure', (tester) async {
      when(() => profileBloc.state).thenReturn(
        const ProfileFailure(error: 'error'),
      );
      await tester.pumpWidget(
        BlocProvider.value(
          value: profileBloc,
          child: const MaterialApp(home: ProfileView()),
        ),
      );
      expect(find.byType(ErrorView), findsOneWidget);
    });

    testWidgets('logs the user out when tapping on the logout button',
        (tester) async {
      when(() => profileBloc.state).thenReturn(
        ProfilePopulated(
          user: _generateUserResponseItem(),
        ),
      );
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: appBloc),
            BlocProvider.value(value: profileBloc),
          ],
          child: const MaterialApp(home: ProfileView()),
        ),
      );
      await tester.ensureVisible(find.byType(ProfileLogOutButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ProfileLogOutButton, skipOffstage: false));
      await tester.pumpAndSettle();
      verify(() => appBloc.add(const AppLogoutRequested())).called(1);
    });

    testWidgets('displays only non null user attributes', (tester) async {
      when(() => profileBloc.state).thenReturn(
        ProfilePopulated(
          user: _generateUserResponseItem(
            phone: null,
            address: null,
          ),
        ),
      );
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: profileBloc),
          ],
          child: const MaterialApp(home: ProfileView()),
        ),
      );
      expect(find.byIcon(EvaIcons.phoneOutline), findsNothing);
      expect(find.byIcon(EvaIcons.pinOutline), findsNothing);
      expect(find.byIcon(EvaIcons.globe), findsOneWidget);
      expect(find.byIcon(EvaIcons.emailOutline), findsOneWidget);
    });

    testWidgets('displays the correct text for the according Widget',
        (tester) async {
      when(() => profileBloc.state).thenReturn(
        ProfilePopulated(
          user: _generateUserResponseItem(
            familyName: 'mustermann',
            phone: '+49 1234',
            email: 'test@email.com',
            address: 'Test address',
            homepage: 'test.com',
          ),
        ),
      );
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: profileBloc),
          ],
          child: const MaterialApp(home: ProfileView()),
        ),
      );
      expect(
        find.widgetWithText(OptionalProfileAttribute, '+49 1234'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(OptionalProfileAttribute, 'test@email.com'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(OptionalProfileAttribute, 'Test address'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(OptionalProfileAttribute, 'test.com'),
        findsOneWidget,
      );
    });
  });
}

UserResponseItem _generateUserResponseItem({
  String? userId,
  String? username,
  String? formattedName,
  String? familyName,
  String? phone = '123456789',
  String? homepage = 'https://google.com',
  String? address = 'Abcstrasse 1',
  String? email,
}) {
  return UserResponseItem(
    id: userId ?? '123',
    attributes: UserResponseItemAttributes(
      username: username ?? 'username_123',
      formattedName: formattedName ?? 'formattedName_123',
      familyName: familyName ?? 'Family Name',
      givenName: 'Name',
      namePrefix: '',
      nameSuffix: '',
      permission: '',
      email: email ?? 'max@mustermann.de',
      phone: phone,
      homepage: homepage,
      address: address,
    ),
    meta: UserResponseItemMeta(
      avatar: UserResponseItemMetaAvatar(
        smallAvatarUrl: '',
        mediumAvatarUrl: '',
        normalAvatarUrl: '',
        originalAvatarUrl: '',
      ),
    ),
  );
}
