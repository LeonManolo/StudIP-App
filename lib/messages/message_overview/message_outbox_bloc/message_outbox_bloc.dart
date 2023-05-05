import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/message_overview/message_outbox_bloc/message_outbox_event.dart';
import 'package:studipadawan/messages/message_overview/message_outbox_bloc/message_outbox_state.dart';

const String unexpectedErrorMessage =
    "Es ist ein unbekannter Fehler aufgetreten, bitte versuche es erneut";
const String messagedDeleteErrorMessage =
    "Es konnten nicht alle Nachrichten gelöscht werden";
const String messagesDeleteSucceedMessage = "Die Nachrichten wurden gelöscht";

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
    on<DeleteOutboxMessagesRequested>(_onDeleteOutboxMessagesRequested);
  }

  FutureOr<void> _onOutboxMessagesRequested(
      OutboxMessagesRequested event, Emitter<OutboxMessageState> emit) async {
    if (state.outboxMessages.isEmpty) {
      emit(state.copyWith(
          status: OutboxMessageStatus.loading,
          paginationLoading: false,
          maxReached: false,
          outboxMessages: []));
    } else {
      emit(state.copyWith(
          status: OutboxMessageStatus.paginationLoading,
          paginationLoading: true,
          outboxMessages: state.outboxMessages));
    }

    try {
      List<Message> outboxMessages =
          await fetchOutboxMessages(offset: event.offset);

      emit(state.copyWith(
          status: OutboxMessageStatus.populated,
          maxReached: outboxMessages.length < limit,
          paginationLoading: false,
          outboxMessages: [...state.outboxMessages, ...outboxMessages]));
    } catch (e) {
      emit(const OutboxMessageState(
          status: OutboxMessageStatus.failure, message: unexpectedErrorMessage));
    }
  }

  FutureOr<void> _onDeleteOutboxMessagesRequested(
      DeleteOutboxMessagesRequested event,
      Emitter<OutboxMessageState> emit) async {
    emit(state.copyWith(
        status: OutboxMessageStatus.loading,
        paginationLoading: false,
        maxReached: state.maxReached,
        currentOffset: state.currentOffset,
        outboxMessages: state.outboxMessages));

    List<String> deletedMessages = [];
    try {
      for (var messageId in event.messageIds) {
        await _messageRepository.deleteMessage(messageId: messageId);
        deletedMessages.add(messageId);
      }
      List<Message> outboxMessages = await _messageRepository.getOutboxMessages(
        userId: _authenticationRepository.currentUser.id,
        offset: state.currentOffset,
        limit: limit,
      );
      emit(state.copyWith(
          status: OutboxMessageStatus.deleteOutboxMessagesSucceed,
          maxReached: outboxMessages.length < limit,
          paginationLoading: false,
          message: messagesDeleteSucceedMessage,
          outboxMessages: [
            ...state.outboxMessages
                .where((message) => !event.messageIds.contains(message.id))
                .toList(),
            ...outboxMessages
          ]));
    } catch (_) {
      emit(state.copyWith(
          status: OutboxMessageStatus.deleteOutboxMessagesFailure,
          maxReached: state.maxReached,
          paginationLoading: false,
          message: messagedDeleteErrorMessage,
          outboxMessages: state.outboxMessages
              .where((message) => !deletedMessages.contains(message.id))
              .toList()));
    }
  }

  FutureOr<void> _onRefreshRequested(
      RefreshOutboxRequested event, Emitter<OutboxMessageState> emit) async {
    emit(state.copyWith(
        status: OutboxMessageStatus.loading,
        paginationLoading: false,
        maxReached: false,
        outboxMessages: []));
    try {
      List<Message> outboxMessages = await _messageRepository.getOutboxMessages(
        userId: _authenticationRepository.currentUser.id,
        offset: 0,
        limit: limit,
      );

      emit(state.copyWith(
          status: OutboxMessageStatus.populated,
          maxReached: outboxMessages.isEmpty,
          paginationLoading: false,
          outboxMessages: outboxMessages));
    } catch (e) {
      emit(const OutboxMessageState(
          status: OutboxMessageStatus.failure, message: unexpectedErrorMessage));
    }
  }

  Future<List<Message>> fetchOutboxMessages({required int offset}) async {
    return await _messageRepository.getOutboxMessages(
      userId: _authenticationRepository.currentUser.id,
      offset: offset,
      limit: limit,
    );
  }
}
