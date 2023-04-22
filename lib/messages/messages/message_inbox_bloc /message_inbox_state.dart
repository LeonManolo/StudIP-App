import 'package:equatable/equatable.dart';
import 'package:messages_repository/messages_repository.dart';

enum InboxMessageStatus {
  initial,
  loading,
  populated,
  failure,
}

enum MessageFilter {
  none("Kein Filter"),
  read("Ungelesene Nachrichten"),
  unread("Gelesene Nachrichten");

  const MessageFilter(this.description);
  final String description;
}

class InboxMessageState extends Equatable {
  final InboxMessageStatus status;
  final List<Message> inboxMessages;
  final MessageFilter currentFilter;

  const InboxMessageState({
    required this.status,
    this.inboxMessages = const [],
    this.currentFilter = MessageFilter.none,
  });

  const InboxMessageState.initial()
      : this(
          status: InboxMessageStatus.initial,
        );

  @override
  List<Object?> get props => [status, inboxMessages, currentFilter];

  InboxMessageState copyWith({
    InboxMessageStatus? status,
    List<Message>? inboxMessages,
    MessageFilter? currentFilter,
  }) {
    return InboxMessageState(
        status: status ?? this.status,
        inboxMessages: inboxMessages ?? this.inboxMessages,
        currentFilter: currentFilter ?? this.currentFilter);
  }
}
