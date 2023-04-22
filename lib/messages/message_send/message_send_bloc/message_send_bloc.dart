import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'message_send_event.dart';
import 'message_send_state.dart';

class MessageSendBloc extends Bloc<MessageSendEvent, MessageSendState> {
  final MessageRepository _messageRepository;

  MessageSendBloc(
      {required MessageRepository messageRepository,
      required UserRepository userRepository})
      : _messageRepository = messageRepository,
        super(const MessageSendState.initial()) {
    on<SendMessageRequest>(_onSendMessageRequested);
  }

  FutureOr<void> _onSendMessageRequested(
      SendMessageRequest event, Emitter<MessageSendState> emit) async {
    emit(state.copyWith(status: MessageSendStatus.loading));

    try {
      await _messageRepository.sendMessage(event.message);
      emit(state.copyWith(
          status: MessageSendStatus.populated));
    } catch (e) {
      emit(const MessageSendState(status: MessageSendStatus.failure));
    }
  }
}
