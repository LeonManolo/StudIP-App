import 'dart:async';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc/message_inbox_event.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc/message_inbox_state.dart';

const String unexpectedErrorMessage =
    'Es ist ein unbekannter Fehler aufgetreten, bitte versuche es erneut';
const String messagesDeleteError =
    'Es konnten nicht alle Nachrichten gelöscht werden';
const String messageDeleteError = 'Die Nachricht konnte nicht gelöscht werden';
const String messagesDeleteSucceed = 'Die Nachrichten wurden gelöscht';
const String messageDeleteSucceed = 'Die Nachricht wurde gelöscht';

class InboxMessageBloc
    extends HydratedBloc<InboxMessageEvent, InboxMessageState> {
  InboxMessageBloc({
    required MessageRepository messageRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _messageRepository = messageRepository,
        _authenticationRepository = authenticationRepository,
        super(
          const InboxMessageStateInitial(
            currentFilter: InboxMessageState.defaultFilter,
          ),
        ) {
    on<InboxMessagesRequested>(_onInboxMessagesRequested);
    on<RefreshInboxRequested>(_onRefreshRequested);
    on<DeleteInboxMessagesRequested>(_onDeleteInboxMessagesRequested);
  }
  final MessageRepository _messageRepository;
  final AuthenticationRepository _authenticationRepository;
  final int limit = 20;

  @override
  InboxMessageState? fromJson(Map<String, dynamic> json) {
    final rawSavedFilter = json['messageFilter'];
    if (rawSavedFilter is! String) {
      return null;
    }
    final MessageFilter savedFilter =
        MessageFilter.values.byName(rawSavedFilter);
    return InboxMessageStateInitial(currentFilter: savedFilter);
  }

  @override
  Map<String, dynamic>? toJson(InboxMessageState state) {
    return {'messageFilter': state.currentFilter.name};
  }

  Future<void> _onInboxMessagesRequested(
    InboxMessagesRequested event,
    Emitter<InboxMessageState> emit,
  ) async {
    if (state.inboxMessages.isEmpty ||
        (event.newFilter != state.currentFilter && event.newFilter != null)) {
      emit(
        InboxMessageStateLoading.fromState(
          state.copyWith(
            inboxMessages: [],
            paginationLoading: false,
            currentFilter: event.newFilter,
          ),
        ),
      );
    } else {
      emit(
        InboxMessageStateDidLoad.fromState(
          state.copyWith(
            paginationLoading: true,
            currentFilter: event.newFilter,
          ),
        ),
      );
    }

    try {
      final inboxMessages = await _fetchInboxMessages(
        offset: event.offset,
        filter: state.currentFilter,
      );

      emit(
        InboxMessageStateDidLoad.fromState(
          state.copyWith(
            maxReached: inboxMessages.length < limit,
            paginationLoading: false,
            inboxMessages: [
              ...state.inboxMessages,
              ...inboxMessages,
            ],
          ),
        ),
      );
    } catch (e) {
      Logger().e(e);
      emit(
        const InboxMessageStateError(
          failureInfo: unexpectedErrorMessage,
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
    } catch (e) {
      Logger().e(e);
      emit(
        const InboxMessageStateError(
          failureInfo: unexpectedErrorMessage,
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
            successInfo: event.messageIds.length == 1
                ? messageDeleteSucceed
                : messagesDeleteSucceed,
            inboxMessages: inboxMessages,
          ),
        ),
      );
    } catch (e) {
      Logger().e(e);
      emit(
        InboxMessageStateDeleteError.fromState(
          state.copyWith(
            paginationLoading: false,
            failureInfo: event.messageIds.length == 1
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
