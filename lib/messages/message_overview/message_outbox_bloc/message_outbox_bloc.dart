import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc%20/message_inbox_bloc.dart';
import 'package:studipadawan/messages/message_overview/message_outbox_bloc/message_outbox_event.dart';
import 'package:studipadawan/messages/message_overview/message_outbox_bloc/message_outbox_state.dart';

class OutboxMessageBloc extends Bloc<OutboxMessageEvent, OutboxMessageState> {
  OutboxMessageBloc({
    required MessageRepository messageRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _messageRepository = messageRepository,
        _authenticationRepository = authenticationRepository,
        super(const OutboxMessageState.initial()) {
    on<OutboxMessagesRequested>(_onOutboxMessagesRequested);
    on<RefreshOutboxRequested>(_onRefreshRequested);
    on<DeleteOutboxMessagesRequested>(_onDeleteOutboxMessagesRequested);
  }
  final MessageRepository _messageRepository;
  final AuthenticationRepository _authenticationRepository;
  final int limit = 20;

  FutureOr<void> _onOutboxMessagesRequested(
    OutboxMessagesRequested event,
    Emitter<OutboxMessageState> emit,
  ) async {
    if (state.outboxMessages.isEmpty) {
      emit(
        state.copyWith(
          status: OutboxMessageStatus.loading,
          paginationLoading: false,
          maxReached: false,
          outboxMessages: [],
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: OutboxMessageStatus.paginationLoading,
          paginationLoading: true,
          outboxMessages: state.outboxMessages,
        ),
      );
    }

    try {
      final List<Message> outboxMessages =
          await _fetchOutboxMessages(offset: event.offset);

      emit(
        state.copyWith(
          status: OutboxMessageStatus.populated,
          maxReached: outboxMessages.length < limit,
          paginationLoading: false,
          outboxMessages: [...state.outboxMessages, ...outboxMessages],
        ),
      );
    } catch (e) {
      emit(
        const OutboxMessageState(
          status: OutboxMessageStatus.failure,
          message: unexpectedErrorMessage,
        ),
      );
    }
  }

  FutureOr<void> _onDeleteOutboxMessagesRequested(
    DeleteOutboxMessagesRequested event,
    Emitter<OutboxMessageState> emit,
  ) async {
    emit(
      state.copyWith(
        status: OutboxMessageStatus.loading,
        paginationLoading: false,
      ),
    );
    try {
      await _messageRepository.deleteMessages(messageIds: event.messageIds);
      final List<Message> outboxMessages =
          await _fetchOutboxMessages(offset: 0);

      emit(
        state.copyWith(
          status: OutboxMessageStatus.deleteOutboxMessagesSucceed,
          maxReached: outboxMessages.length < limit,
          paginationLoading: false,
          message: event.messageIds.length == 1
              ? messageDeleteSucceed
              : messagesDeleteSucceed,
          outboxMessages: [...outboxMessages],
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: OutboxMessageStatus.deleteOutboxMessagesFailure,
          paginationLoading: false,
          message: event.messageIds.length == 1
              ? messageDeleteError
              : messagesDeleteError,
        ),
      );
    }
  }

  FutureOr<void> _onRefreshRequested(
    RefreshOutboxRequested event,
    Emitter<OutboxMessageState> emit,
  ) async {
    emit(
      state.copyWith(
        status: OutboxMessageStatus.loading,
        paginationLoading: false,
        maxReached: false,
        outboxMessages: [],
      ),
    );
    try {
      final List<Message> outboxMessages =
          await _messageRepository.getOutboxMessages(
        userId: _authenticationRepository.currentUser.id,
        offset: 0,
        limit: limit,
      );

      emit(
        state.copyWith(
          status: OutboxMessageStatus.populated,
          maxReached: outboxMessages.isEmpty,
          paginationLoading: false,
          outboxMessages: outboxMessages,
        ),
      );
    } catch (e) {
      emit(
        const OutboxMessageState(
          status: OutboxMessageStatus.failure,
          message: unexpectedErrorMessage,
        ),
      );
    }
  }

  Future<List<Message>> _fetchOutboxMessages({required int offset}) async {
    return _messageRepository.getOutboxMessages(
      userId: _authenticationRepository.currentUser.id,
      offset: offset,
      limit: limit,
    );
  }
}
