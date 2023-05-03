import 'dart:async';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'message_inbox_event.dart';
import 'message_inbox_state.dart';

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
  }

  Future<void> _onInboxMessagesRequested(
    InboxMessagesRequested event,
    Emitter<InboxMessageState> emit,
  ) async {
    if (state.inboxMessages.isEmpty || event.filter != state.currentFilter) {
      emit(state.copyWith(
        status: InboxMessageStatus.inboxMessagesLoading,
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
      final inboxMessages = await _messageRepository.getInboxMessages(
        userId: _authenticationRepository.currentUser.id,
        offset: event.offset,
        limit: limit,
        filterUnread: event.filter == MessageFilter.unread,
      );

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
      emit(const InboxMessageState(status: InboxMessageStatus.failure));
    }
  }

  Future<void> _onRefreshRequested(
    RefreshInboxRequested event,
    Emitter<InboxMessageState> emit,
  ) async {
    emit(state.copyWith(
      status: InboxMessageStatus.inboxMessagesLoading,
      inboxMessages: [],
      paginationLoading: false,
      currentFilter: state.currentFilter,
    ));

    try {
      final inboxMessages = await _messageRepository.getInboxMessages(
        userId: _authenticationRepository.currentUser.id,
        offset: 0,
        limit: limit,
        filterUnread: state.currentFilter == MessageFilter.unread,
      );

      emit(state.copyWith(
        status: InboxMessageStatus.populated,
        currentFilter: state.currentFilter,
        maxReached: inboxMessages.isEmpty,
        paginationLoading: false,
        inboxMessages: inboxMessages,
      ));
    } catch (_) {
      emit(const InboxMessageState(status: InboxMessageStatus.failure));
    }
  }

  FutureOr<void> _onReadMessageRequested(
      ReadMessageRequested event, Emitter<InboxMessageState> emit) async {
    await _messageRepository.readMessage(messageId: event.message.id);
  }
}
