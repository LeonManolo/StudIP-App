import 'package:equatable/equatable.dart';
import 'package:messages_repository/messages_repository.dart';

abstract class MessageSendEvent extends Equatable {
  const MessageSendEvent();
}

class SendMessageRequested extends MessageSendEvent {
  const SendMessageRequested({required this.subject, required this.messageText});
  final String subject;
  final String messageText;

  @override
  List<Object?> get props => [subject, messageText];
}

class AddRecipientRequested extends MessageSendEvent {
  const AddRecipientRequested({required this.recipient});
  final MessageUser recipient;

  @override
  List<Object?> get props => [recipient];
}

class RemoveRecipientRequested extends MessageSendEvent {
  const RemoveRecipientRequested({required this.recipient});
  final MessageUser recipient;

  @override
  List<Object?> get props => [recipient];
}

class FetchSuggestionsRequested extends MessageSendEvent {
  const FetchSuggestionsRequested({required this.pattern});
  final String pattern;
  @override
  List<Object?> get props => [pattern];
}
