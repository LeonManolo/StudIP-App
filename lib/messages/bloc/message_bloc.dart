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
  }

  FutureOr<void> _onRefreshRequested(
      RefreshRequested event, Emitter<MessageState> emit) async {
    emit(state.copyWith(status: MessageStatus.loading, messages: []));

    try {
      List<Message> messages;
      if (event.isInbox) {
        messages = await _messageRepository
            .getInboxMessages(_authenticationRepository.currentUser.id);
      } else {
        messages = await _messageRepository
            .getOutboxMessages(_authenticationRepository.currentUser.id);
      }
      emit(state.copyWith(
          status: MessageStatus.populated,
          messages: event.isInbox
              ? filter(messages, event.filter).toList()
              : messages));
    } catch (e) {
      emit(const MessageState(status: MessageStatus.failure));
    }
  }

  getMessages(bool isInbox) async {
    try {
      if (isInbox) {
        return await _messageRepository
            .getInboxMessages(_authenticationRepository.currentUser.id);
      } else {
        return await _messageRepository
            .getOutboxMessages(_authenticationRepository.currentUser.id);
      }
    } catch (e) {
      emit(const MessageState(status: MessageStatus.failure));
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
