import 'dart:async';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'message_inbox_event.dart';
import 'message_inbox_state.dart';

const String unexpectedErrorMessage =
    "Es ist ein unbekannter Fehler aufgetreten, bitte versuche es erneut";
const String messagedDeleteErrorMessage = "Es konnten nicht alle Nachrichten gelöscht werden";
const String messagesDeleteSucceedMessage = "Die Nachrichten wurden gelöscht";

class InboxMessageBloc extends Bloc<InboxMessageEvent, InboxMessageState> {
  final MessageRepository _messageRepository;
  final AuthenticationRepository _authenticationRepository;
  final int limit = 20;

  InboxMessageBloc({
    required MessageRepository messageRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _messageRepository = messageRepository,
        _authenticationRepository = authenticationRepository,
        super(const InboxMessageState.initial()) {
    on<InboxMessagesRequested>(_onInboxMessagesRequested);
    on<RefreshInboxRequested>(_onRefreshRequested);
    on<ReadMessageRequested>(_onReadMessageRequested);
    on<DeleteInboxMessagesRequested>(_onDeleteInboxMessagesRequested);
  }

  Future<void> _onInboxMessagesRequested(
    InboxMessagesRequested event,
    Emitter<InboxMessageState> emit,
  ) async {
    if (state.inboxMessages.isEmpty || event.filter != state.currentFilter) {
      emit(state.copyWith(
        status: InboxMessageStatus.loading,
        inboxMessages: [],
        paginationLoading: false,
        currentFilter: event.filter,
      ));
    } else {
      emit(state.copyWith(
        status: InboxMessageStatus.paginationLoading,
        inboxMessages: state.inboxMessages,
        paginationLoading: true,
        currentFilter: event.filter,
      ));
    }

    try {
      final inboxMessages =
          await fetchInboxMessages(offset: event.offset, filter: event.filter);

      emit(state.copyWith(
        status: InboxMessageStatus.populated,
        currentFilter: event.filter,
        maxReached: inboxMessages.length < limit,
        paginationLoading: false,
        inboxMessages: [
          ...state.inboxMessages,
          ...inboxMessages,
        ],
      ));
    } catch (_) {
      emit(const InboxMessageState(
          status: InboxMessageStatus.failure, message: unexpectedErrorMessage));
    }
  }

  Future<void> _onRefreshRequested(
    RefreshInboxRequested event,
    Emitter<InboxMessageState> emit,
  ) async {
    emit(state.copyWith(
      status: InboxMessageStatus.loading,
      inboxMessages: [],
      paginationLoading: false,
      currentFilter: state.currentFilter,
    ));

    try {
      final inboxMessages =
          await fetchInboxMessages(offset: 0, filter: state.currentFilter);

      emit(state.copyWith(
        status: InboxMessageStatus.populated,
        currentFilter: state.currentFilter,
        maxReached: inboxMessages.length < limit,
        paginationLoading: false,
        inboxMessages: inboxMessages,
      ));
    } catch (_) {
      emit(const InboxMessageState(
          status: InboxMessageStatus.failure,
          message:
              unexpectedErrorMessage));
    }
  }

  FutureOr<void> _onDeleteInboxMessagesRequested(
      DeleteInboxMessagesRequested event,
      Emitter<InboxMessageState> emit) async {
    List<String> deletedMessages = [];
    emit(state.copyWith(
        status: InboxMessageStatus.loading,
        maxReached: state.maxReached,
        paginationLoading: false,
        currentOffset: state.currentOffset,
        currentFilter: state.currentFilter,
        inboxMessages: state.inboxMessages));
    try {
      for (var messageId in event.messageIds) {
        await _messageRepository.deleteMessage(messageId: messageId);
        deletedMessages.add(messageId);
      }
      final inboxMessages = await fetchInboxMessages(
          offset: state.currentOffset, filter: state.currentFilter);

      emit(state.copyWith(
          status: InboxMessageStatus.deleteInboxMessagesSucceed,
          currentFilter: state.currentFilter,
          maxReached: state.maxReached,
          paginationLoading: false,
          message: messagesDeleteSucceedMessage,
          inboxMessages: [
            ...state.inboxMessages
                .where((message) => !event.messageIds.contains(message.id))
                .toList(),
            ...inboxMessages
          ]));
    } catch (_) {
      emit(state.copyWith(
          status: InboxMessageStatus.deleteInboxMessagesFailure,
          currentFilter: state.currentFilter,
          maxReached: state.maxReached,
          paginationLoading: false,
          message: messagedDeleteErrorMessage,
          inboxMessages: state.inboxMessages
              .where((message) => !deletedMessages.contains(message.id))
              .toList()));
    }
  }

  FutureOr<void> _onReadMessageRequested(
      ReadMessageRequested event, Emitter<InboxMessageState> emit) async {
    await _messageRepository.readMessage(messageId: event.message.id);
  }

  Future<List<Message>> fetchInboxMessages(
      {required int offset, required MessageFilter filter}) async {
    return await _messageRepository.getInboxMessages(
        userId: _authenticationRepository.currentUser.id,
        offset: offset,
        limit: limit,
        filterUnread: filter == MessageFilter.unread);
  }
}
