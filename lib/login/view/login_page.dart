import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/login/cubit/login_cubit.dart';
import 'package:studipadawan/login/cubit/login_state.dart';
import 'package:studipadawan/utils/loading_indicator.dart';
import 'package:studipadawan/utils/utils.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(context.read<AuthenticationRepository>()),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state == LoginState.failure) {
            buildSnackBar(context, 'Fehler beim Anmelden', null);
          }
        },
        builder: (context, state) {
          switch (state) {
            case LoginState.inProgress:
              return const LoadingIndicator();
            case _:
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Login'),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.close),
                    )
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StudIpLoginButton(),
                    ],
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}

class _StudIpLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton.icon(
      key: const Key('loginForm_googleLogin_raisedButton'),
      label: const Text(
        'SIGN IN WITH STUD IP',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: theme.colorScheme.secondary,
      ),
      icon: const Icon(Icons.person, color: Colors.white),
      onPressed: () => context.read<LoginCubit>().loginWithStudIp(),
    );
  }
}
