import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/bloc/message_event.dart';
import 'package:studipadawan/messages/bloc/message_state.dart';

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
    emit(state.copyWith(status: MessageStatus.loading, outboxMessages: []));

    try {
      List<Message> outboxMessages = await _messageRepository
          .getOutboxMessages(_authenticationRepository.currentUser.id);
      emit(state.copyWith(
          status: MessageStatus.populated,
          outboxMessages: outboxMessages));
    } catch (e) {
      emit(const OutboxMessageState(status: MessageStatus.failure));
    }
  }
}
