import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/view/messages/bloc/message_event.dart';
import 'package:studipadawan/messages/view/messages/bloc/message_state.dart';

class InboxMessageBloc extends Bloc<InboxMessageEvent, InboxMessageState> {
  final MessageRepository _messageRepository;
  final AuthenticationRepository _authenticationRepository;

  InboxMessageBloc(
      {required MessageRepository messageRepository,
      required AuthenticationRepository authenticationRepository})
      : _messageRepository = messageRepository,
        _authenticationRepository = authenticationRepository,
        super(const InboxMessageState.initial()) {
    on<InboxMessagesRequested>(_onInboxMessagesRequested);
    on<ReadMessageRequested>(_onReadMessageRequested);
  }

  FutureOr<void> _onInboxMessagesRequested(
      InboxMessagesRequested event, Emitter<InboxMessageState> emit) async {
    emit(state.copyWith(status: MessageStatus.loading, inboxMessages: []));

    try {
      List<Message> inboxMessages = await _messageRepository
          .getInboxMessages(_authenticationRepository.currentUser.id);
      emit(state.copyWith(
          status: MessageStatus.populated,
          inboxMessages: filter(inboxMessages, event.filter)));
    } catch (e) {
      emit(const InboxMessageState(status: MessageStatus.failure));
    }
  }

  FutureOr<void> _onReadMessageRequested(
      ReadMessageRequested event, Emitter<InboxMessageState> emit) async {
    await _messageRepository.readMessage(event.messageId);
  }

  List<Message> filter(List<Message> messages, MessageFilter filter) {
    switch (filter) {
      case MessageFilter.read:
        return messages.where((message) => message.isRead).toList();
      case MessageFilter.unread:
        return messages.where((message) => !message.isRead).toList();
      default:
        return messages;
    }
  }
}
