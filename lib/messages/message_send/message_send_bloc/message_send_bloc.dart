import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'message_send_event.dart';
import 'message_send_state.dart';

const String unexpectedError = "Ein unerwarteter Fehler ist aufgetreten";
const String missingSubjectError = "Bitte gebe einen Betreff ein";
const String missingMessageError = "Bitte gebe eine Nachricht ein";

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

    if (event.message.subject.isEmpty) {
      emit(const MessageSendState(
          status: MessageSendStatus.failure,
          errorMessage: missingSubjectError));
    } else if (event.message.message.isEmpty) {
      emit(const MessageSendState(
          status: MessageSendStatus.failure,
          errorMessage: missingMessageError));
    } else {
      try {
        await _messageRepository.sendMessage(outgoingMessage: event.message);
        emit(state.copyWith(status: MessageSendStatus.populated));
      } catch (e) {
        emit(const MessageSendState(
            status: MessageSendStatus.failure, errorMessage: unexpectedError));
      }
    }
  }
}
