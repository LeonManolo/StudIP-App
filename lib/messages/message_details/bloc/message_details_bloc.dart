import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'message_details_event.dart';
import 'message_details_state.dart';

const String messageDeleteErrorMessage =
    "Es konnten nicht alle Nachrichten gelöscht werden";
const String messageDeleteSucceedMessage = "Die Nachrichten wurde gelöscht";

class MessageDetailsBloc
    extends Bloc<MessageDetailsEvent, MessageDetailsState> {
  final MessageRepository _messageRepository;

  MessageDetailsBloc({
    required MessageRepository messageRepository,
  })  : _messageRepository = messageRepository,
        super(const MessageDetailsState.initial()) {
    on<DeleteMessageRequested>(_onDeleteMessageRequested);
  }

  FutureOr<void> _onDeleteMessageRequested(
      DeleteMessageRequested event, Emitter<MessageDetailsState> emit) async {
    emit(const MessageDetailsState(status: MessageDetailsStatus.loading));
    try {
      await _messageRepository.deleteMessage(messageId: event.messageId);

      emit(const MessageDetailsState(
          status: MessageDetailsStatus.deleteMessageSucceed,
          message: messageDeleteSucceedMessage));
    } catch (_) {
      emit(const MessageDetailsState(
          status: MessageDetailsStatus.deleteMessageFailure,
          message: messageDeleteSucceedMessage));
    }
  }
}
