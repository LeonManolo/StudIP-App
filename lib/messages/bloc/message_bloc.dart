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

    if (state.isInbox) {
      final messages = await _messageRepository
          .getInboxMessages(_authenticationRepository.currentUser.id);
      emit(MessageState(status: MessageStatus.populated, messages: messages));
    } else {
      final messages = await _messageRepository
          .getOutboxMessages(_authenticationRepository.currentUser.id);
      emit(MessageState(status: MessageStatus.populated, messages: messages));
    }
  }

  FutureOr<void> _onFilterRequested(
      RefreshRequested event, Emitter<MessageState> emit) async {
    emit(state.copyWith(status: MessageStatus.loading));
    List<Message> messages;
    if (state.isInbox) {
      messages = await _messageRepository
          .getInboxMessages(_authenticationRepository.currentUser.id);
    } else {
      messages = await _messageRepository
          .getOutboxMessages(_authenticationRepository.currentUser.id);
    }
    emit(MessageState(
        status: MessageStatus.populated,
        messages: filter(messages, state.filter)));
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
  }

  filter(List<Message> messages, MessageFilter filter) {
    switch (filter) {
      case MessageFilter.read:
        return messages.where((message) => message.isRead);
      case MessageFilter.unread:
        return messages.where((message) => !message.isRead);
      default:
        return messages;
    }
  }
}
