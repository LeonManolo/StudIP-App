import 'package:equatable/equatable.dart';
import 'package:messages_repository/messages_repository.dart';

abstract class MessageSendEvent extends Equatable {
  const MessageSendEvent();
}

class SendMessageRequest extends MessageSendEvent {

  const SendMessageRequest({required this.message});
  final OutgoingMessage message;

  @override
  List<Object?> get props => [message];
}
