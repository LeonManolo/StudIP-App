import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'message_users_event.dart';
import 'message_users_state.dart';

class MessageUsersBloc extends Bloc<MessageUsersEvent, MessageUsersState> {
  final UserRepository _userRepository;

  MessageUsersBloc(
      {
      required UserRepository userRepository})
      :
        _userRepository = userRepository,
        super(const MessageUsersState.initial()) {
    on<MessageUsersRequested>(_onUsersRequested);
  }

  FutureOr<void> _onUsersRequested(
      MessageUsersRequested event, Emitter<MessageUsersState> emit) async {
    emit(state.copyWith(status: MessageUserState.loading));

    try {
      final users = await _userRepository.getUsers();
      emit(state.copyWith(
          status: MessageUserState.populated, users: users.users));
    } catch (e) {
      emit(const MessageUsersState(status: MessageUserState.failure));
    }
  }
}
