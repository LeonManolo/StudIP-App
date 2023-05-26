import 'package:equatable/equatable.dart';
import 'package:messages_repository/messages_repository.dart';

abstract class MessageDetailsEvent extends Equatable {
  const MessageDetailsEvent();
}

class DeleteMessageRequested extends MessageDetailsEvent {
  const DeleteMessageRequested({required this.messageId});
  final String messageId;

  @override
  List<Object?> get props => [messageId];
}

class ReadMessageRequested extends MessageDetailsEvent {
  const ReadMessageRequested({required this.message});
  final Message message;

  @override
  List<Object?> get props => [message];
}
