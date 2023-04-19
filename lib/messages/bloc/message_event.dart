import 'package:equatable/equatable.dart';
import 'package:messages_repository/messages_repository.dart';

import 'message_state.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();
}

class RefreshRequested extends MessageEvent {
  final MessageFilter filter;

  const RefreshRequested({required this.filter});

  @override
  List<Object?> get props => [filter];
}



class MessageRequested extends MessageEvent {
  final Message message;

  const MessageRequested({required this.message});

  @override
  List<Object?> get props => [message];
}

class ReadMessageRequested extends MessageEvent {
  final String messageId;

  const ReadMessageRequested({required this.messageId});

  @override
  List<Object?> get props => [messageId];
}
