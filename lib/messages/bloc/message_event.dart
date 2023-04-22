import 'package:equatable/equatable.dart';

import 'message_state.dart';

abstract class InboxMessageEvent extends Equatable {
  const InboxMessageEvent();
}

abstract class OutboxMessageEvent extends Equatable {
  const OutboxMessageEvent();
}

class InboxMessagesRequested extends InboxMessageEvent {
  final MessageFilter filter;

  const InboxMessagesRequested({required this.filter});

  @override
  List<Object?> get props => [filter];
}

class ReadMessageRequested extends InboxMessageEvent {
  final String messageId;

  const ReadMessageRequested({required this.messageId});

  @override
  List<Object?> get props => [messageId];
}
class OutboxMessagesRequested extends OutboxMessageEvent {

  const OutboxMessagesRequested();

  @override
  List<Object?> get props => [];
}
