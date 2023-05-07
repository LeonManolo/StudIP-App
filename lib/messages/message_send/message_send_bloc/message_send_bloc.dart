import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:user_repository/user_repository.dart';
import '../../message_overview/message_inbox_bloc /message_inbox_bloc.dart';
import 'message_send_event.dart';
import 'message_send_state.dart';


const String missingSubjectErrorMessage = "Bitte gebe einen Betreff ein";
const String missingMessageErrorMessage = "Bitte gebe eine Nachricht ein";
const String missingRecipientErrorMessage = "Bitte wähle einen Benutzer";
const String messageSentMessage = "Die Nachricht wurde versendet";

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
          message: missingSubjectErrorMessage));
    } else if (event.message.message.isEmpty) {
      emit(const MessageSendState(
          status: MessageSendStatus.failure,
          message: missingMessageErrorMessage));
    } else {
      try {
        await _messageRepository.sendMessage(outgoingMessage: event.message);
        emit(state.copyWith(
            status: MessageSendStatus.populated, message: messageSentMessage));
      } catch (e) {
        emit(const MessageSendState(
            status: MessageSendStatus.failure,
            message: unexpectedErrorMessage));
      }
    }
  }
}
