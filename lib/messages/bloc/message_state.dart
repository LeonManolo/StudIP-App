import 'package:equatable/equatable.dart';
import 'package:messages_repository/messages_repository.dart';

enum MessageStatus {
  initial,
  loading,
  populated,
  failure,
}

enum MessageFilter { none, read, unread }

enum TabBarState { inbox, outbox }

class MessageState extends Equatable {
  final MessageStatus status;
  final List<Message> messages;
  final bool isInbox;
  final MessageFilter filter;

  const MessageState(
      {required this.status,
      this.messages = const [],
      this.isInbox = true,
      this.filter = MessageFilter.none});

  const MessageState.initial()
      : this(
          status: MessageStatus.initial,
        );

  @override
  List<Object?> get props => [isInbox, messages, filter];

  MessageState copyWith({
    MessageStatus? status,
    List<Message>? messages,
    bool? isInbox,
    MessageFilter? filter,
  }) {
    return MessageState(
        status: status ?? this.status,
        messages: messages ?? this.messages,
        isInbox: isInbox ?? this.isInbox,
        filter: filter ?? this.filter);
  }
}
