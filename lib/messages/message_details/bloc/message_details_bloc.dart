import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/message_details/bloc/message_details_event.dart';
import 'package:studipadawan/messages/message_details/bloc/message_details_state.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc%20/message_inbox_bloc.dart';

class MessageDetailsBloc
    extends Bloc<MessageDetailsEvent, MessageDetailState> {
  MessageDetailsBloc({
    required MessageRepository messageRepository,
  })  : _messageRepository = messageRepository,
        super(const MessageDetailStateInitial()) {
    on<DeleteMessageRequested>(_onDeleteMessageRequested);
    on<ReadMessageRequested>(_onReadMessageRequested);
  }
  final MessageRepository _messageRepository;

  FutureOr<void> _onDeleteMessageRequested(
    DeleteMessageRequested event,
    Emitter<MessageDetailState> emit,
  ) async {
    emit(const MessageDetailStateLoading());
    try {
      await _messageRepository.deleteMessage(messageId: event.messageId);

      emit(
        const MessageDetailStateDeleteMessageSucceed(
          blocResponse: messageDeleteSucceed,
        ),
      );
    } catch (_) {
      emit(
        const MessageDetailStateDeleteMessageError(
          blocResponse: messageDeleteSucceed,
        ),
      );
    }
  }

  FutureOr<void> _onReadMessageRequested(
    ReadMessageRequested event,
    Emitter<MessageDetailState> emit,
  ) async {
    await _messageRepository.readMessage(messageId: event.message.id);
  }
}
