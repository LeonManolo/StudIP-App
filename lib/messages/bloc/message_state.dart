import 'package:equatable/equatable.dart';
import 'package:messages_repository/messages_repository.dart';

enum MessageStatus {
  initial,
  loading,
  populated,
  failure,
}

enum MessageFilter { none, read, unread }

class MessageState extends Equatable {
  final MessageStatus status;
  final List<Message> inboxMessages;
  final List<Message> outboxMessages;
  final MessageFilter filter;

  const MessageState(
      {required this.status,
      this.inboxMessages = const [],
      this.outboxMessages = const [],
      this.filter = MessageFilter.none});

  const MessageState.initial()
      : this(
          status: MessageStatus.initial,
        );

  @override
  List<Object?> get props => [status, inboxMessages, outboxMessages, filter];

  MessageState copyWith({
    MessageStatus? status,
    List<Message>? inboxMessages,
    List<Message>? outboxMessages,
    MessageFilter? filter,
  }) {
    return MessageState(
        status: status ?? this.status,
        inboxMessages: inboxMessages ?? this.inboxMessages,
        outboxMessages: outboxMessages ?? this.outboxMessages,
        filter: filter ?? this.filter);
  }
}
