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
        super(const InboxMessageStateInitial()) {
    on<InboxMessagesRequested>(_onInboxMessagesRequested);
    on<RefreshInboxRequested>(_onRefreshRequested);
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
        InboxMessageStateLoading.fromState(
          state.copyWith(
            inboxMessages: [],
            paginationLoading: false,
            currentFilter: event.filter,
          ),
        ),
      );
    } else {
      emit(
        InboxMessageStateDidLoad.fromState(
          state.copyWith(
            paginationLoading: true,
            currentFilter: event.filter,
          ),
        ),
      );
    }

    try {
      final inboxMessages =
          await _fetchInboxMessages(offset: event.offset, filter: event.filter);

      emit(
        InboxMessageStateDidLoad.fromState(
          state.copyWith(
            currentFilter: event.filter,
            maxReached: inboxMessages.length < limit,
            paginationLoading: false,
            inboxMessages: [
              ...state.inboxMessages,
              ...inboxMessages,
            ],
          ),
        ),
      );
    } catch (_) {
      emit(
        const InboxMessageStateError(
          blocResponse: unexpectedErrorMessage,
        ),
      );
    }
  }

  Future<void> _onRefreshRequested(
    RefreshInboxRequested event,
    Emitter<InboxMessageState> emit,
  ) async {
    emit(
      InboxMessageStateLoading.fromState(
        state.copyWith(
          inboxMessages: [],
          paginationLoading: false,
        ),
      ),
    );

    try {
      final inboxMessages =
          await _fetchInboxMessages(offset: 0, filter: state.currentFilter);

      emit(
        InboxMessageStateDidLoad.fromState(
          state.copyWith(
            maxReached: inboxMessages.length < limit,
            paginationLoading: false,
            inboxMessages: inboxMessages,
          ),
        ),
      );
    } catch (_) {
      emit(
        const InboxMessageStateError(
          blocResponse: unexpectedErrorMessage,
        ),
      );
    }
  }

  FutureOr<void> _onDeleteInboxMessagesRequested(
    DeleteInboxMessagesRequested event,
    Emitter<InboxMessageState> emit,
  ) async {
    emit(
      InboxMessageStateLoading.fromState(
        state.copyWith(
          paginationLoading: false,
        ),
      ),
    );

    try {
      await _messageRepository.deleteMessages(messageIds: event.messageIds);
      final inboxMessages =
          await _fetchInboxMessages(offset: 0, filter: state.currentFilter);

      emit(
        InboxMessageStateDeleteSucceed.fromState(
          state.copyWith(
            paginationLoading: false,
            maxReached: inboxMessages.length < limit,
            blocResponse: event.messageIds.length == 1
                ? messageDeleteSucceed
                : messagesDeleteSucceed,
            inboxMessages: inboxMessages,
          ),
        ),
      );
    } catch (_) {
      emit(
        InboxMessageStateDeleteError.fromState(
          state.copyWith(
            paginationLoading: false,
            blocResponse: event.messageIds.length == 1
                ? messageDeleteError
                : messagesDeleteError,
          ),
        ),
      );
    }
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
