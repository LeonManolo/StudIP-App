import 'package:app_ui/app_ui.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:files_repository/files_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return MaterialApp(
      theme: const AppTheme().themeData,
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}
