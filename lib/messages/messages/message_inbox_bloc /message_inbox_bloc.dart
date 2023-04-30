import 'dart:async';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'message_inbox_event.dart';
import 'message_inbox_state.dart';

class InboxMessageBloc extends Bloc<InboxMessageEvent, InboxMessageState> {
  final MessageRepository _messageRepository;
  final AuthenticationRepository _authenticationRepository;

  InboxMessageBloc(
      {required MessageRepository messageRepository,
      required AuthenticationRepository authenticationRepository})
      : _messageRepository = messageRepository,
        _authenticationRepository = authenticationRepository,
        super(const InboxMessageState.initial()) {
    on<InboxMessagesRequested>(_onInboxMessagesRequested);
    on<RefreshRequested>(_onRefreshRequested);
    on<ReadMessageRequested>(_onReadMessageRequested);
  }

  FutureOr<void> _onInboxMessagesRequested(
      InboxMessagesRequested event, Emitter<InboxMessageState> emit) async {
    if (state.inboxMessages.isEmpty || event.filter != state.currentFilter) {
      emit(state.copyWith(
          status: InboxMessageStatus.loading,
          inboxMessages: [],
          currentFilter: event.filter));
    } else {
      emit(state.copyWith(
          status: InboxMessageStatus.paginationLoading,
          inboxMessages: state.inboxMessages,
          paginationLoading: true,
          currentFilter: event.filter));
    }
    try {
      List<Message> inboxMessages = await _messageRepository.getInboxMessages(
          userId: _authenticationRepository.currentUser.id,
          offset: event.offset,
          limit: 20,
          filterUnread: event.filter == MessageFilter.unread);

      if (event.filter == MessageFilter.read) {
        _filterRead(inboxMessages);
      }

      emit(state.copyWith(
          status: InboxMessageStatus.populated,
          currentFilter: event.filter,
          maxReached: inboxMessages.isEmpty,
          paginationLoading: false,
          inboxMessages: [...state.inboxMessages, ...inboxMessages]));
    } catch (e) {
      emit(const InboxMessageState(status: InboxMessageStatus.failure));
    }
  }

  FutureOr<void> _onRefreshRequested(
      RefreshRequested event, Emitter<InboxMessageState> emit) async {
    emit(state.copyWith(
        status: InboxMessageStatus.loading,
        inboxMessages: [],
        currentFilter: state.currentFilter));
    try {
      List<Message> inboxMessages = await _messageRepository.getInboxMessages(
          userId: _authenticationRepository.currentUser.id,
          offset: 0,
          limit: 20,
          filterUnread: state.currentFilter == MessageFilter.unread);
      if (state.currentFilter == MessageFilter.read) {
        _filterRead(inboxMessages);
      }
      emit(state.copyWith(
          status: InboxMessageStatus.populated,
          currentFilter: state.currentFilter,
          maxReached: inboxMessages.isEmpty,
          inboxMessages: inboxMessages));
    } catch (e) {
      emit(const InboxMessageState(status: InboxMessageStatus.failure));
    }
  }

  FutureOr<void> _onReadMessageRequested(
      ReadMessageRequested event, Emitter<InboxMessageState> emit) async {
    await _messageRepository.readMessage(messageId: event.message.id);
  }

  void _filterRead(List<Message> messages) {
    messages = messages.where((message) => message.isRead).toList();
  }
}
