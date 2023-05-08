import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc%20/message_inbox_bloc.dart';
import 'package:studipadawan/messages/message_send/message_send_bloc/message_send_event.dart';
import 'package:studipadawan/messages/message_send/message_send_bloc/message_send_state.dart';


const String missingSubjectErrorMessage = 'Bitte gebe einen Betreff ein';
const String missingMessageErrorMessage = 'Bitte gebe eine Nachricht ein';
const String missingRecipientErrorMessage = 'Bitte wähle einen Benutzer';
const String messageSentMessage = 'Die Nachricht wurde versendet';

class MessageSendBloc extends Bloc<MessageSendEvent, MessageSendState> {

  MessageSendBloc(
      {required MessageRepository messageRepository,})
      : _messageRepository = messageRepository,
        super(const MessageSendState.initial()) {
    on<SendMessageRequest>(_onSendMessageRequested);
  }
  final MessageRepository _messageRepository;

  FutureOr<void> _onSendMessageRequested(
      SendMessageRequest event, Emitter<MessageSendState> emit,) async {
    emit(state.copyWith(status: MessageSendStatus.loading));

    if (event.message.subject.isEmpty) {
      emit(const MessageSendState(
          status: MessageSendStatus.failure,
          message: missingSubjectErrorMessage,),);
    } else if (event.message.message.isEmpty) {
      emit(const MessageSendState(
          status: MessageSendStatus.failure,
          message: missingMessageErrorMessage,),);
    } else {
      try {
        await _messageRepository.sendMessage(outgoingMessage: event.message);
        emit(state.copyWith(
            status: MessageSendStatus.populated, message: messageSentMessage,),);
      } catch (e) {
        emit(const MessageSendState(
            status: MessageSendStatus.failure,
            message: unexpectedErrorMessage,),);
      }
    }
  }
}
