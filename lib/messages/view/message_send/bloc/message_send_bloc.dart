import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/view/messages/bloc/message_event.dart';
import 'package:studipadawan/messages/view/messages/bloc/message_state.dart';

import 'message_send_event.dart';
import 'message_send_state.dart';

class MessageSendBloc extends Bloc<MessageSendEvent, MessageSendState> {
  final MessageRepository _messageRepository;

  MessageSendBloc(
      {required MessageRepository messageRepository})
      : _messageRepository = messageRepository,
        super(const MessageSendState.initial()) {
    on<SendMessageRequested>(_onSendMessageRequested);
  }

  FutureOr<void> _onSendMessageRequested(
      SendMessageRequested event, Emitter<MessageSendState> emit) async {
        print("test");
    emit(state.copyWith(
        status: MessageSendStatus.loading));

    try {
      await _messageRepository.sendMessage(event.message);
      emit(state.copyWith(
          status: MessageSendStatus.populated));
    } catch (e) {
      emit(const MessageSendState(status: MessageSendStatus.failure));
    }
  }
}
