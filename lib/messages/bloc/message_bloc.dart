import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/bloc/message_event.dart';
import 'package:studipadawan/messages/bloc/message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageRepository _messageRepository;
  final AuthenticationRepository _authenticationRepository;

  MessageBloc(
      {required MessageRepository messageRepository,
      required AuthenticationRepository authenticationRepository})
      : _messageRepository = messageRepository,
        _authenticationRepository = authenticationRepository,
        super(const MessageState.initial()) {
    on<RefreshRequested>(_onRefreshRequested);
    on<InboxOutboxToggleBoxDidChange>(_onToggleBoxChange);
  }

  FutureOr<void> _onRefreshRequested(
      RefreshRequested event, Emitter<MessageState> emit) async {
    emit(state.copyWith(status: MessageStatus.loading, messages: []));

    try {
      if (state.isInbox) {
        final messages = await _messageRepository
            .getInboxMessages(_authenticationRepository.currentUser.id);
        emit(MessageState(status: MessageStatus.populated, messages: messages));
      } else {
        final messages = await _messageRepository
            .getOutboxMessages(_authenticationRepository.currentUser.id);
        emit(MessageState(status: MessageStatus.populated, messages: messages));
      }
    } catch (e) {
      emit(const MessageState(status: MessageStatus.failure));
    }
  }

  FutureOr<void> _onToggleBoxChange(
      InboxOutboxToggleBoxDidChange event, Emitter<MessageState> emit) async {
    final newToggleBoxState = [for (var i = 0; i < 2; i += 1) i]
        .map((index) => index == event.index)
        .toList();

    emit(state.copyWith(
        status: MessageStatus.loading,
        messages: [],
        toggleBoxStates: newToggleBoxState));

    try {
      if (event.index == 0) {
        emit(
          state.copyWith(
              status: MessageStatus.populated,
              messages: await _messageRepository
                  .getInboxMessages(_authenticationRepository.currentUser.id)),
        );
      } else {
        emit(
          state.copyWith(
              status: MessageStatus.populated,
              messages: await _messageRepository
                  .getOutboxMessages(_authenticationRepository.currentUser.id)),
        );
      }
    } catch (e) {
      emit(const MessageState(status: MessageStatus.failure));
    }
  }
}
