import 'package:equatable/equatable.dart';
import 'package:messages_repository/messages_repository.dart';

abstract class MessageSendEvent extends Equatable {
  const MessageSendEvent();
}

class SendMessageRequest extends MessageSendEvent {

  const SendMessageRequest({required this.subject, required this.messageText});
  final String subject;
  final String messageText;

  @override
  List<Object?> get props => [subject, messageText];
}

class AddRecipient extends MessageSendEvent {

  const AddRecipient({required this.recipient});
  final MessageUser recipient;

  @override
  List<Object?> get props => [recipient];
}
class RemoveRecipient extends MessageSendEvent {

  const RemoveRecipient({required this.recipient});
  final MessageUser recipient;

  @override
  List<Object?> get props => [recipient];
}
