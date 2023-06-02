import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_widget/home_widget.dart';
import 'package:studipadawan/login/cubit/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  factory LoginCubit(AuthenticationRepository authenticationRepository) {
    return LoginCubit._(authenticationRepository);
  }
  LoginCubit._(this._authenticationRepository) : super(LoginState.idle);

  final AuthenticationRepository _authenticationRepository;

  Future<void> loginWithStudIp() async {
    emit(LoginState.inProgress);
    try {
      await _authenticationRepository.loginWithStudIp();
      unawaited(HomeWidget.updateWidget(iOSName: 'StudipadawanWidgets'));

      emit(LoginState.success);
    } catch (_) {
      emit(LoginState.failure);
    }
  }
}
