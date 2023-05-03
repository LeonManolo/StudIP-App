import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/message_overview/message_outbox_bloc/message_outbox_event.dart';
import 'package:studipadawan/messages/message_overview/message_outbox_bloc/message_outbox_state.dart';

class OutboxMessageBloc extends Bloc<OutboxMessageEvent, OutboxMessageState> {
  final MessageRepository _messageRepository;
  final AuthenticationRepository _authenticationRepository;
  final int limit = 20;

  OutboxMessageBloc(
      {required MessageRepository messageRepository,
      required AuthenticationRepository authenticationRepository})
      : _messageRepository = messageRepository,
        _authenticationRepository = authenticationRepository,
        super(const OutboxMessageState.initial()) {
    on<OutboxMessagesRequested>(_onOutboxMessagesRequested);
    on<RefreshOutboxRequested>(_onRefreshRequested);
  }

  FutureOr<void> _onOutboxMessagesRequested(
      OutboxMessagesRequested event, Emitter<OutboxMessageState> emit) async {
    if (state.outboxMessages.isEmpty) {
      emit(state.copyWith(
          status: OutboxMessageStatus.outboxMessagesLoading,
          paginationLoading: false,
          outboxMessages: []));
    } else {
      emit(state.copyWith(
          status: OutboxMessageStatus.paginationLoading,
          paginationLoading: true,
          outboxMessages: state.outboxMessages));
    }

    try {
      List<Message> outboxMessages = await _messageRepository.getOutboxMessages(
          userId: _authenticationRepository.currentUser.id,
          offset: event.offset,
          limit: limit);

      emit(state.copyWith(
          status: OutboxMessageStatus.populated,
          maxReached: outboxMessages.length < limit,
          paginationLoading: false,
          outboxMessages: [...state.outboxMessages, ...outboxMessages]));
    } catch (e) {
      emit(const OutboxMessageState(status: OutboxMessageStatus.failure));
    }
  }

  FutureOr<void> _onRefreshRequested(
      RefreshOutboxRequested event, Emitter<OutboxMessageState> emit) async {
    emit(state.copyWith(
        status: OutboxMessageStatus.outboxMessagesLoading, outboxMessages: []));
    try {
      List<Message> outboxMessages = await _messageRepository.getOutboxMessages(
        userId: _authenticationRepository.currentUser.id,
        offset: 0,
        limit: limit,
      );

      emit(state.copyWith(
          status: OutboxMessageStatus.populated,
          outboxMessages: outboxMessages));
    } catch (e) {
      emit(const OutboxMessageState(status: OutboxMessageStatus.failure));
    }
  }
}
