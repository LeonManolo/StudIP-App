import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/view/messages/bloc/message_event.dart';
import 'package:studipadawan/messages/view/messages/bloc/message_state.dart';

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
    on<ReadMessageRequested>(_onReadMessageRequested);
  }

  FutureOr<void> _onReadMessageRequested(
      ReadMessageRequested event, Emitter<MessageState> emit) async {
        emit(state.copyWith(
        status: MessageStatus.loading, inboxMessages: [], outboxMessages: []));
    try {
      await _messageRepository.readMessage(event.messageId);
    } catch (e) {
      print(e);
      //emit(const MessageState(status: MessageStatus.failure));
    }
  }

  FutureOr<void> _onRefreshRequested(
      RefreshRequested event, Emitter<MessageState> emit) async {
    emit(state.copyWith(
        status: MessageStatus.loading, inboxMessages: [], outboxMessages: []));

    try {
      List<Message> inboxMessages = await _messageRepository
          .getInboxMessages(_authenticationRepository.currentUser.id);
      List<Message> outboxMessages = await _messageRepository
          .getOutboxMessages(_authenticationRepository.currentUser.id);
      emit(state.copyWith(
          status: MessageStatus.populated,
          inboxMessages: filter(inboxMessages, event.filter),
          outboxMessages: outboxMessages));
    } catch (e) {
      emit(const MessageState(status: MessageStatus.failure));
    }
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
