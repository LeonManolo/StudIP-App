import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc%20/message_inbox_bloc.dart';
import 'package:studipadawan/messages/message_send/message_send_bloc/message_send_event.dart';
import 'package:studipadawan/messages/message_send/message_send_bloc/message_send_state.dart';
import 'package:user_repository/user_repository.dart';

const String missingSubjectErrorMessage = 'Bitte gebe einen Betreff ein';
const String missingMessageErrorMessage = 'Bitte gebe eine Nachricht ein';
const String missingRecipientErrorMessage = 'Bitte wähle einen Empfänger';
const String fetcUserSuggestionsErrorMessage =
    'Es ist ein unbekannter Fehelr aufgetreten';
const String messageSentMessage = 'Die Nachricht wurde versendet';

class MessageSendBloc extends Bloc<MessageSendEvent, MessageSendState> {
  MessageSendBloc({
    required MessageRepository messageRepository,
    required UserRepository userRepository,
  })  : _messageRepository = messageRepository,
        _userRepository = userRepository,
        super(const MessageSendState.initial()) {
    on<SendMessageRequest>(_onSendMessageRequested);
    on<AddRecipient>(_onAddRecipientRequested);
    on<RemoveRecipient>(_onRemoveRecipientRequested);
    on<FetchSuggestions>(_onSuggestionsRequested);
  }
  final MessageRepository _messageRepository;
  final UserRepository _userRepository;

  FutureOr<void> _onSendMessageRequested(
    SendMessageRequest event,
    Emitter<MessageSendState> emit,
  ) async {
    if (state.recipients.isEmpty) {
      emit(
        state.copyWith(
          status: MessageSendStatus.failure,
          blocResponse: missingRecipientErrorMessage,
        ),
      );
    } else if (event.subject.isEmpty) {
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
        status: MessageSendStatus.recipientsChanged,
        recipients: recipients,
      ),
    );
  }

  Future<void> _onSuggestionsRequested(
    FetchSuggestions event,
    Emitter<MessageSendState> emit,
  ) async {
    try {
      final usersResponse = await _userRepository.getUsers(event.pattern);
      emit(
        state.copyWith(
          status: MessageSendStatus.userSuggestionsFetched,
          suggestions: usersResponse.userResponses
              .map(MessageUser.fromUserResponse)
              .toList(),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: MessageSendStatus.userSuggestionsFailure,
          blocResponse: fetcUserSuggestionsErrorMessage,
          suggestions: [],
        ),
      );
    }
  }

  void _onRemoveRecipientRequested(
    RemoveRecipient event,
    Emitter<MessageSendState> emit,
  ) {
    final recipients = [...state.recipients]
      ..removeWhere((recipient) => recipient.id == event.recipient.id);

    emit(
      state.copyWith(
        status: MessageSendStatus.recipientsChanged,
        recipients: recipients,
      ),
    );
  }
}
