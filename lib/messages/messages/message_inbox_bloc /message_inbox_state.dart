import 'package:equatable/equatable.dart';
import 'package:messages_repository/messages_repository.dart';

enum InboxMessageStatus {
  initial,
  inboxMessagesLoading,
  paginationLoading,
  populated,
  failure
}

enum MessageFilter {
  none("Kein Filter"),
  unread("Ungelesene Nachrichten");
  const MessageFilter(this.description);
  final String description;
}

class InboxMessageState extends Equatable {
  final InboxMessageStatus status;
  final List<Message> inboxMessages;
  final MessageFilter currentFilter;
  final int currentOffset;
  final bool maxReached;
  final bool paginationLoading;

  const InboxMessageState(
      {required this.status,
      this.inboxMessages = const [],
      this.currentFilter = MessageFilter.none,
      this.currentOffset = 0,
      this.maxReached = false,
      this.paginationLoading = false});

  const InboxMessageState.initial()
      : this(
          status: InboxMessageStatus.initial,
        );

  @override
  List<Object?> get props =>
      [status, inboxMessages, currentFilter, paginationLoading];

  InboxMessageState copyWith(
      {InboxMessageStatus? status,
      List<Message>? inboxMessages,
      MessageFilter? currentFilter,
      int? currentOffset,
      bool? maxReached,
      bool? paginationLoading}) {
    return InboxMessageState(
        status: status ?? this.status,
        inboxMessages: inboxMessages ?? this.inboxMessages,
        currentFilter: currentFilter ?? this.currentFilter,
        currentOffset: currentOffset ?? this.currentOffset,
        maxReached: maxReached ?? this.maxReached,
        paginationLoading: paginationLoading ?? this.paginationLoading);
  }
}
