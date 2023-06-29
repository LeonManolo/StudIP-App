import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:studip_api_client/studip_api_client.dart';
import 'package:user_repository/user_repository.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const ProfileInitial()) {
    on<ProfileRequested>(_onProfileRequested);
  }

  final UserRepository _userRepository;

  FutureOr<void> _onProfileRequested(
      ProfileRequested event, Emitter<ProfileState> emit) async {
    emit(const ProfileLoading());
    try {
      final user = await _userRepository.getCurrentUser();
      emit(
        ProfilePopulated(
          user: user.userResponseItem,
        ),
      );
    } catch (e) {
      Logger().e(e);
      emit(ProfileFailure(error: e.toString()));
    }
  }
}
