import 'dart:async';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc%20/message_inbox_event.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc%20/message_inbox_state.dart';

const String unexpectedErrorMessage =
    'Es ist ein unbekannter Fehler aufgetreten, bitte versuche es erneut';
const String messagesDeleteError =
    'Es konnten nicht alle Nachrichten gelöscht werden';
const String messageDeleteError = 'Die Nachricht konnte nicht gelöscht werden';
const String messagesDeleteSucceed = 'Die Nachrichten wurden gelöscht';
const String messageDeleteSucceed = 'Die Nachricht wurde gelöscht';

class InboxMessageBloc extends Bloc<InboxMessageEvent, InboxMessageState> {
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
  final MessageRepository _messageRepository;
  final AuthenticationRepository _authenticationRepository;
  final int limit = 20;

  Future<void> _onInboxMessagesRequested(
    InboxMessagesRequested event,
    Emitter<InboxMessageState> emit,
  ) async {
    if (state.inboxMessages.isEmpty || event.filter != state.currentFilter) {
      emit(
        state.copyWith(
          status: InboxMessageStatus.loading,
          inboxMessages: [],
          paginationLoading: false,
          currentFilter: event.filter,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: InboxMessageStatus.paginationLoading,
          inboxMessages: state.inboxMessages,
          paginationLoading: true,
          currentFilter: event.filter,
        ),
      );
    }

    try {
      final inboxMessages =
          await _fetchInboxMessages(offset: event.offset, filter: event.filter);

      emit(
        state.copyWith(
          status: InboxMessageStatus.populated,
          currentFilter: event.filter,
          maxReached: inboxMessages.length < limit,
          paginationLoading: false,
          inboxMessages: [
            ...state.inboxMessages,
            ...inboxMessages,
          ],
        ),
      );
    } catch (_) {
      emit(
        const InboxMessageState(
          status: InboxMessageStatus.failure,
          message: unexpectedErrorMessage,
        ),
      );
    }
  }

  Future<void> _onRefreshRequested(
    RefreshInboxRequested event,
    Emitter<InboxMessageState> emit,
  ) async {
    emit(
      state.copyWith(
        status: InboxMessageStatus.loading,
        inboxMessages: [],
        paginationLoading: false,
        currentFilter: state.currentFilter,
      ),
    );

    try {
      final inboxMessages =
          await _fetchInboxMessages(offset: 0, filter: state.currentFilter);

      emit(
        state.copyWith(
          status: InboxMessageStatus.populated,
          currentFilter: state.currentFilter,
          maxReached: inboxMessages.length < limit,
          paginationLoading: false,
          inboxMessages: inboxMessages,
        ),
      );
    } catch (_) {
      emit(
        const InboxMessageState(
          status: InboxMessageStatus.failure,
          message: unexpectedErrorMessage,
        ),
      );
    }
  }

  FutureOr<void> _onDeleteInboxMessagesRequested(
    DeleteInboxMessagesRequested event,
    Emitter<InboxMessageState> emit,
  ) async {
    emit(
      state.copyWith(
        status: InboxMessageStatus.loading,
        paginationLoading: false,
      ),
    );
    try {
      await _messageRepository.deleteMessages(messageIds: event.messageIds);
      final inboxMessages =
          await _fetchInboxMessages(offset: 0, filter: state.currentFilter);

      emit(
        state.copyWith(
          status: InboxMessageStatus.deleteInboxMessagesSucceed,
          paginationLoading: false,
          message: event.messageIds.length == 1
              ? messageDeleteSucceed
              : messagesDeleteSucceed,
          inboxMessages: inboxMessages,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: InboxMessageStatus.deleteInboxMessagesFailure,
          paginationLoading: false,
          message: event.messageIds.length == 1
              ? messageDeleteError
              : messagesDeleteError,
        ),
      );
    }
  }

  FutureOr<void> _onReadMessageRequested(
    ReadMessageRequested event,
    Emitter<InboxMessageState> emit,
  ) async {
    await _messageRepository.readMessage(messageId: event.message.id);
  }

  Future<List<Message>> _fetchInboxMessages({
    required int offset,
    required MessageFilter filter,
  }) async {
    return _messageRepository.getInboxMessages(
      userId: _authenticationRepository.currentUser.id,
      offset: offset,
      limit: limit,
      filterUnread: filter == MessageFilter.unread,
    );
  }
}
