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

    List<Message> messages = await getMessages(event.isInbox);
    emit(state.copyWith(
        status: MessageStatus.populated,
        messages: event.isInbox
            ? filter(messages, event.filter).toList()
            : messages));
  }

  getMessages(bool isInbox) async {
    if (isInbox) {
      return await _messageRepository
          .getInboxMessages(_authenticationRepository.currentUser.id);
    } else {
      return await _messageRepository
          .getOutboxMessages(_authenticationRepository.currentUser.id);
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
