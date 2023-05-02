import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository) : super(LoginState.idle);

  final AuthenticationRepository _authenticationRepository;


  Future<void> loginWithStudIp() async {
    emit(LoginState.inProgress);
    try {
      await _authenticationRepository.loginWithStudIp();
      emit(LoginState.success);
    } on Exception { // LogInWithGoogleFailure
      emit(
        LoginState.failure,
      );
    } catch (_) {
      emit(LoginState.failure);
    }
  }
}