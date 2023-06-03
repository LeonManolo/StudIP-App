import 'package:app_ui/app_ui.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:files_repository/files_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/app/bloc/app_bloc.dart';
import 'package:studipadawan/app/routes/routes.dart';
import 'package:user_repository/user_repository.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
    required CourseRepository coursesRepository,
    required MessageRepository messageRepository,
    required CalenderRepository calenderRepository,
    required FilesRepository filesRepository,
  })  : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        _courseRepository = coursesRepository,
        _messageRepository = messageRepository,
        _calenderRepository = calenderRepository,
        _filesRepository = filesRepository;

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  final CourseRepository _courseRepository;
  final MessageRepository _messageRepository;
  final CalenderRepository _calenderRepository;
  final FilesRepository _filesRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authenticationRepository),
        RepositoryProvider.value(value: _userRepository),
        RepositoryProvider.value(value: _courseRepository),
        RepositoryProvider.value(value: _messageRepository),
        RepositoryProvider.value(value: _calenderRepository),
        RepositoryProvider.value(value: _filesRepository)
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AppBloc(
              authenticationRepository: _authenticationRepository,
            ),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final materialDarkTheme = ThemeData.dark();
    final materialLightTheme = ThemeData.light();


    const darkDefaultCupertinoTheme =
    CupertinoThemeData(brightness: Brightness.dark);
    final cupertinoDarkTheme = MaterialBasedCupertinoThemeData(
      materialTheme: materialDarkTheme.copyWith(
        useMaterial3: true,
        cupertinoOverrideTheme: CupertinoThemeData(
          brightness: Brightness.dark,
          barBackgroundColor: darkDefaultCupertinoTheme.barBackgroundColor,
          textTheme: CupertinoTextThemeData(
            primaryColor: Colors.white,
            navActionTextStyle:
            darkDefaultCupertinoTheme.textTheme.navActionTextStyle.copyWith(
              color: const Color(0xF0F9F9F9),
            ),
            navLargeTitleTextStyle: darkDefaultCupertinoTheme
                .textTheme.navLargeTitleTextStyle
                .copyWith(color: Colors.red),
          ),
        ),
      ),
    );
    final cupertinoDarkTheme2 = CupertinoThemeData(
      brightness: Brightness.dark,
      //barBackgroundColor: Color(0xf0f9f9f9),
      //applyThemeToAll: true,
    );

    final cupertinoLightTheme =
    MaterialBasedCupertinoThemeData(materialTheme: materialLightTheme);

    return PlatformProvider(
      settings: PlatformSettingsData(
          iosUsesMaterialWidgets: true,
      ),
      builder: (context) => PlatformTheme(
        themeMode: ThemeMode.light,
        materialLightTheme: const LightMaterialAppTheme().themeData,
        materialDarkTheme: materialDarkTheme,
        cupertinoDarkTheme: cupertinoDarkTheme2,
        cupertinoLightTheme: const CupertinoThemeData(
          brightness: Brightness.light,
          primaryColor: CupertinoColors.systemIndigo,
        ),
        matchCupertinoSystemChromeBrightness: false,
        builder: (context) => PlatformApp(
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
          ],
          title: 'StudIPadawan',
          home: FlowBuilder<AppStatus>(
            state: context.select((AppBloc bloc) => bloc.state.status),
            onGeneratePages: onGenerateAppViewPages,
          ),
        ),
      ),
    );
  }
}
