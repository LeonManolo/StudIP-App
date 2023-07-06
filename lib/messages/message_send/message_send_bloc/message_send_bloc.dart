import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc/message_inbox_bloc.dart';
import 'package:studipadawan/messages/message_send/message_send_bloc/message_send_event.dart';
import 'package:studipadawan/messages/message_send/message_send_bloc/message_send_state.dart';

const String missingSubjectErrorMessage = 'Bitte gebe einen Betreff ein';
const String missingMessageErrorMessage = 'Bitte gebe eine Nachricht ein';
const String missingRecipientErrorMessage = 'Bitte wähle einen Empfänger';
const String fetchUserSuggestionsErrorMessage =
    'Es ist ein unbekannter Fehlerr aufgetreten';
const String messageSentMessage = 'Die Nachricht wurde versendet';

class MessageSendBloc extends Bloc<MessageSendEvent, MessageSendState> {
  MessageSendBloc({
    required MessageRepository messageRepository,
  })  : _messageRepository = messageRepository,
        super(const MessageSendStateInitial()) {
    on<SendMessageRequested>(_onSendMessageRequested);
    on<AddRecipientRequested>(_onAddRecipientRequested);
    on<RemoveRecipientRequested>(_onRemoveRecipientRequested);
    on<FetchSuggestionsRequested>(_onFetchSuggestionsRequested);
  }
  final MessageRepository _messageRepository;

  FutureOr<void> _onSendMessageRequested(
    SendMessageRequested event,
    Emitter<MessageSendState> emit,
  ) async {
    if (state.recipients.isEmpty) {
      emit(
        MessageSendStateError.fromState(
          state.copyWith(
            failureInfo: missingRecipientErrorMessage,
          ),
        ),
      );
    } else if (event.subject.isEmpty) {
      emit(
        MessageSendStateError.fromState(
          state.copyWith(
            failureInfo: missingSubjectErrorMessage,
          ),
        ),
      );
    } else if (event.messageText.isEmpty) {
      emit(
        MessageSendStateError.fromState(
          state.copyWith(
            failureInfo: missingMessageErrorMessage,
          ),
        ),
      );
    } else {
      emit(
        MessageSendStateLoading.fromState(state),
      );
      try {
        await _messageRepository.sendMessage(
          outgoingMessage: OutgoingMessage(
            subject: event.subject,
            message: event.messageText,
            recipients:
                state.recipients.map((recipient) => recipient.id).toList(),
          ),
        );
        emit(
          const MessageSendStateDidLoad(
            successInfo: messageSentMessage,
          ),
        );
      } catch (e) {
        Logger().e(e);
        emit(
          MessageSendStateError.fromState(
            state.copyWith(
              failureInfo: unexpectedErrorMessage,
            ),
          ),
        );
      }
    }
  }

  void _onAddRecipientRequested(
    AddRecipientRequested event,
    Emitter<MessageSendState> emit,
  ) {
    final recipients = [
      ...state.recipients,
      ...[event.recipient]
    ];
    emit(
      MessageSendStateRecipientsChanged.fromState(
        state.copyWith(
          recipients: recipients,
        ),
      ),
    );
  }

  Future<void> _onFetchSuggestionsRequested(
    FetchSuggestionsRequested event,
    Emitter<MessageSendState> emit,
  ) async {
    try {
      final users =
          await _messageRepository.searchUsers(searchParam: event.pattern);
      emit(
        MessageSendStateUserSuggestionsFetched.fromState(
          state.copyWith(
            suggestions: users,
          ),
        ),
      );
    } catch (e) {
      Logger().e(e);
      emit(
        MessageSendStateUserSuggestionsError.fromState(
          state.copyWith(
            failureInfo: fetchUserSuggestionsErrorMessage,
            suggestions: [],
          ),
        ),
      );
    }
  }

  void _onRemoveRecipientRequested(
    RemoveRecipientRequested event,
    Emitter<MessageSendState> emit,
  ) {
    final recipients = [...state.recipients]
      ..removeWhere((recipient) => recipient.id == event.recipient.id);

    emit(
      MessageSendStateRecipientsChanged.fromState(
        state.copyWith(
          recipients: recipients,
        ),
      ),
    );
  }
}
