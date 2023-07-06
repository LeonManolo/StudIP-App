import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/message_details/bloc/message_details_event.dart';
import 'package:studipadawan/messages/message_details/bloc/message_details_state.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc/message_inbox_bloc.dart';

class MessageDetailsBloc
    extends Bloc<MessageDetailsEvent, MessageDetailsState> {
  MessageDetailsBloc({
    required MessageRepository messageRepository,
  })  : _messageRepository = messageRepository,
        super(const MessageDetailsStateInitial()) {
    on<DeleteMessageRequested>(_onDeleteMessageRequested);
    on<ReadMessageRequested>(_onReadMessageRequested);
  }
  final MessageRepository _messageRepository;

  FutureOr<void> _onDeleteMessageRequested(
    DeleteMessageRequested event,
    Emitter<MessageDetailsState> emit,
  ) async {
    emit(const MessageDetailsStateLoading());
    try {
      await _messageRepository.deleteMessage(messageId: event.messageId);

      emit(
        const MessageDetailsStateDeleteSucceed(
          successInfo: messageDeleteSucceed,
        ),
      );
    } catch (_) {
      emit(
        const MessageDetailsStateDeleteError(
          failureInfo: messageDeleteError,
        ),
      );
    }
  }

  FutureOr<void> _onReadMessageRequested(
    ReadMessageRequested event,
    Emitter<MessageDetailsState> emit,
  ) async {
    try {
      await _messageRepository.readMessage(messageId: event.message.id);
    } catch (e) {
      Logger().e(e);
    }
  }
}
