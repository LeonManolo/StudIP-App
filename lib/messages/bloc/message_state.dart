import 'package:equatable/equatable.dart';
import 'package:messages_repository/messages_repository.dart';

enum MessageStatus {
  initial,
  loading,
  populated,
  failure,
}

enum MessageFilter { none, read, unread }

class InboxMessageState extends Equatable {
  final MessageStatus status;
  final List<Message> inboxMessages;
  final MessageFilter filter;

  const InboxMessageState(
      {required this.status,
      this.inboxMessages = const [],
      this.filter = MessageFilter.none,
      });

  const InboxMessageState.initial()
      : this(
          status: MessageStatus.initial,
        );

  @override
  List<Object?> get props => [status, inboxMessages, filter];

  InboxMessageState copyWith({
    MessageStatus? status,
    List<Message>? inboxMessages,
    MessageFilter? filter,
  }) {
    return InboxMessageState(
        status: status ?? this.status,
        inboxMessages: inboxMessages ?? this.inboxMessages,
        filter: filter ?? this.filter);
  }
}

class OutboxMessageState extends Equatable {
  final MessageStatus status;
  final List<Message> outboxMessages;

  const OutboxMessageState(
      {required this.status,
      this.outboxMessages = const [],
      });

  const OutboxMessageState.initial()
      : this(
          status: MessageStatus.initial,
        );

  @override
  List<Object?> get props => [status, outboxMessages];

  OutboxMessageState copyWith({
    MessageStatus? status,
    List<Message>? outboxMessages,
  }) {
    return OutboxMessageState(
        status: status ?? this.status,
        outboxMessages: outboxMessages ?? this.outboxMessages);
  }
}
