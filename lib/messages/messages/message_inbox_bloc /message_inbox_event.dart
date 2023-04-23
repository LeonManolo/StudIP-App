import 'package:equatable/equatable.dart';
import 'package:messages_repository/messages_repository.dart';

import 'message_inbox_state.dart';

abstract class InboxMessageEvent extends Equatable {
  const InboxMessageEvent();
}

class InboxMessagesRequested extends InboxMessageEvent {
  final MessageFilter filter;

  const InboxMessagesRequested({required this.filter});

  @override
  List<Object?> get props => [filter];
}

class ReadMessageRequested extends InboxMessageEvent {
  final Message message;

  const ReadMessageRequested({required this.message});

  @override
  List<Object?> get props => [message];
}