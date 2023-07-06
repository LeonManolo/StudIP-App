import 'package:app_ui/app_ui.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/login/cubit/login_cubit.dart';
import 'package:studipadawan/login/cubit/login_state.dart';
import 'package:studipadawan/login/widgets/login_button.dart';
import 'package:studipadawan/login/widgets/login_illustration.dart';
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
              return const Material(child: LoadingIndicator());

            case _:
              return Scaffold(
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                appBar: AppBar(),
                body: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      const LoginIllustration(),
                      Text(
                        'Anmelden',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: AppSpacing.md,
                          bottom: AppSpacing.xxlg,
                        ),
                        child: Text(
                          'Melde dich jetzt mit deinem\nStud.IP Account an',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ),
                      LoginButton(
                        onPressed: () =>
                            context.read<LoginCubit>().loginWithStudIp(),
                      ),
                      const Spacer(),
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
