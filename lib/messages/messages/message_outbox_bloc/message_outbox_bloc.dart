import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/messages/message_outbox_bloc/message_outbox_event.dart';
import 'package:studipadawan/messages/messages/message_outbox_bloc/message_outbox_state.dart';

class OutboxMessageBloc extends Bloc<OutboxMessageEvent, OutboxMessageState> {
  final MessageRepository _messageRepository;
  final AuthenticationRepository _authenticationRepository;

  OutboxMessageBloc(
      {required MessageRepository messageRepository,
      required AuthenticationRepository authenticationRepository})
      : _messageRepository = messageRepository,
        _authenticationRepository = authenticationRepository,
        super(const OutboxMessageState.initial()) {
    on<OutboxMessagesRequested>(_onOutboxMessagesRequested);
  }

  FutureOr<void> _onOutboxMessagesRequested(
      OutboxMessagesRequested event, Emitter<OutboxMessageState> emit) async {
    emit(state.copyWith(status: OutboxMessageStatus.loading, outboxMessages: []));

    try {
      List<Message> outboxMessages = await _messageRepository
          .getOutboxMessages(userId: _authenticationRepository.currentUser.id, offset: 0);
      emit(state.copyWith(
          status: OutboxMessageStatus.populated,
          outboxMessages: outboxMessages));
    } catch (e) {
      emit(const OutboxMessageState(status: OutboxMessageStatus.failure));
    }
  }
}
