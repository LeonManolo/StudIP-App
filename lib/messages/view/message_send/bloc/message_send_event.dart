import 'package:equatable/equatable.dart';
import 'package:messages_repository/messages_repository.dart';

abstract class MessageSendEvent extends Equatable {
  const MessageSendEvent();
}

class SendMessageRequested extends MessageSendEvent {
  final OutgoingMessage message;

  const SendMessageRequested({required this.message});

  @override
  List<Object?> get props => [message];
}
