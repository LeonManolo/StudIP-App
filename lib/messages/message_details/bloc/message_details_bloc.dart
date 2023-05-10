import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/message_details/bloc/message_details_event.dart';
import 'package:studipadawan/messages/message_details/bloc/message_details_state.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc%20/message_inbox_bloc.dart';

class MessageDetailsBloc
    extends Bloc<MessageDetailsEvent, MessageDetailsState> {
  MessageDetailsBloc({
    required MessageRepository messageRepository,
  })  : _messageRepository = messageRepository,
        super(const MessageDetailsState.initial()) {
    on<DeleteMessageRequested>(_onDeleteMessageRequested);
  }
  final MessageRepository _messageRepository;

  FutureOr<void> _onDeleteMessageRequested(
    DeleteMessageRequested event,
    Emitter<MessageDetailsState> emit,
  ) async {
    emit(const MessageDetailsState(status: MessageDetailsStatus.loading));
    try {
      await _messageRepository.deleteMessage(messageId: event.messageId);

      emit(
        const MessageDetailsState(
          status: MessageDetailsStatus.deleteMessageSucceed,
          blocResponse: messageDeleteSucceed,
        ),
      );
    } catch (_) {
      emit(
        const MessageDetailsState(
          status: MessageDetailsStatus.deleteMessageFailure,
          blocResponse: messageDeleteSucceed,
        ),
      );
    }
  }
}
