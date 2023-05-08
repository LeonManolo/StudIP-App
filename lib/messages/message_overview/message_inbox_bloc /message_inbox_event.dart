import 'package:equatable/equatable.dart';
import 'package:messages_repository/messages_repository.dart';

import 'package:studipadawan/messages/message_overview/message_inbox_bloc%20/message_inbox_state.dart';

abstract class InboxMessageEvent extends Equatable {
  const InboxMessageEvent();
}

class InboxMessagesRequested extends InboxMessageEvent {

  const InboxMessagesRequested({required this.filter, required this.offset});
  final MessageFilter filter;
  final int offset;

  @override
  List<Object?> get props => [filter, offset];
}

class RefreshInboxRequested extends InboxMessageEvent {
  const RefreshInboxRequested();

  @override
  List<Object?> get props => [];
}

class DeleteInboxMessagesRequested extends InboxMessageEvent {

  const DeleteInboxMessagesRequested({required this.messageIds});
  final List<String> messageIds;

  @override
  List<Object?> get props => [messageIds];
}

class ReadMessageRequested extends InboxMessageEvent {

  const ReadMessageRequested({required this.message});
  final Message message;

  @override
  List<Object?> get props => [message];
}
