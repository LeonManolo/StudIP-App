import 'package:equatable/equatable.dart';
import 'package:messages_repository/messages_repository.dart';

import 'message_inbox_state.dart';

abstract class InboxMessageEvent extends Equatable {
  const InboxMessageEvent();
}

class InboxMessagesRequested extends InboxMessageEvent {
  final MessageFilter filter;
  final int offset;

  const InboxMessagesRequested({required this.filter, required this.offset});

  @override
  List<Object?> get props => [filter, offset];
}

class RefreshInboxRequested extends InboxMessageEvent {
  const RefreshInboxRequested();

  @override
  List<Object?> get props => [];
}

class DeleteInboxMessagesRequested extends InboxMessageEvent {
  final List<String> messageIds;

  const DeleteInboxMessagesRequested({required this.messageIds});

  @override
  List<Object?> get props => [messageIds];
}

class ReadMessageRequested extends InboxMessageEvent {
  final Message message;

  const ReadMessageRequested({required this.message});

  @override
  List<Object?> get props => [message];
}
