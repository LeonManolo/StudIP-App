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
  MessageSendBloc({
    required MessageRepository messageRepository,
  })  : _messageRepository = messageRepository,
        super(const MessageSendState.initial()) {
    on<SendMessageRequest>(_onSendMessageRequested);
    on<AddRecipient>(_onAddRecipientRequested);
    on<RemoveRecipient>(_onRemoveRecipientRequested);
  }
  final MessageRepository _messageRepository;

  FutureOr<void> _onSendMessageRequested(
    SendMessageRequest event,
    Emitter<MessageSendState> emit,
  ) async {
    if (event.subject.isEmpty) {
      emit(
        state.copyWith(
          status: MessageSendStatus.failure,
          blocResponse: missingSubjectErrorMessage,
        ),
      );
    } else if (event.messageText.isEmpty) {
      emit(
        state.copyWith(
          status: MessageSendStatus.failure,
          blocResponse: missingMessageErrorMessage,
        ),
      );
    } else if (state.recipients.isEmpty) {
      emit(
        state.copyWith(
          status: MessageSendStatus.failure,
          blocResponse: missingRecipientErrorMessage,
        ),
      );
    } else {
      try {
        await _messageRepository.sendMessage(
          outgoingMessage: OutgoingMessage(
            subject: event.subject,
            message: event.messageText,
            recipients: state.recipients.map((r) => r.id).toList(),
          ),
        );
        emit(
          state.copyWith(
            status: MessageSendStatus.populated,
            blocResponse: messageSentMessage,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            status: MessageSendStatus.failure,
            blocResponse: unexpectedErrorMessage,
          ),
        );
      }
    }
  }

  void _onAddRecipientRequested(
    AddRecipient event,
    Emitter<MessageSendState> emit,
  ) {
    final recipients = [
      ...state.recipients,
      ...[event.recipient]
    ];
    emit(
      state.copyWith(
        status: MessageSendStatus.recipientAdded,
        recipients: recipients,
      ),
    );

  }

  void _onRemoveRecipientRequested(
    RemoveRecipient event,
    Emitter<MessageSendState> emit,
  ) {
    final recipients = [...state.recipients]
      ..removeWhere((recipient) => recipient.id == event.recipient.id);

    emit(
      state.copyWith(
        status: MessageSendStatus.recipientRemoved,
        recipients: recipients,
      ),
    );
  }
}
