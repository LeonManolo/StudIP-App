import 'package:authentication_repository/authentication_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/app/bloc/app_bloc.dart';
import 'package:studipadawan/app/routes/routes.dart';
import 'package:user_repository/src/user_repository.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required AuthenticationRepository authenticationRepository, required UserRepository userRepository,
  }) : _authenticationRepository = authenticationRepository, _userRepository = userRepository;

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authenticationRepository),
        RepositoryProvider.value(value: _userRepository),
      ],
      child: MultiBlocProvider(providers: [
        BlocProvider(
          create: (_) => AppBloc(
            authenticationRepository: _authenticationRepository,
          ),
        )
      ], child: const AppView()),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //theme: theme,
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}