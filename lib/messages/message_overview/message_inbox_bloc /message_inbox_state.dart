import 'package:equatable/equatable.dart';
import 'package:messages_repository/messages_repository.dart';

enum InboxMessageStatus {
  initial,
  loading,
  paginationLoading,
  deleteInboxMessagesSucceed,
  deleteInboxMessagesFailure,
  populated,
  failure
}

enum MessageFilter {
  none("Alle Nachrichten"),
  unread("Ungelesene Nachrichten");

  const MessageFilter(this.description);
  final String description;
}

class InboxMessageState extends Equatable {
  final InboxMessageStatus status;
  final String message;
  final List<Message> inboxMessages;
  final MessageFilter currentFilter;
  final int currentOffset;
  final bool maxReached;
  final bool paginationLoading;
  
  const InboxMessageState(
      {required this.status,
      this.inboxMessages = const [],
      this.currentFilter = MessageFilter.none,
      this.message = "",
      this.currentOffset = 0,
      this.maxReached = false,
      this.paginationLoading = false});

  const InboxMessageState.initial()
      : this(
          status: InboxMessageStatus.initial,
        );

  @override
  List<Object?> get props => [
        status,
        inboxMessages,
        currentFilter,
        currentOffset,
        maxReached,
        message,
        paginationLoading,
      ];

  InboxMessageState copyWith(
      {InboxMessageStatus? status,
      List<Message>? inboxMessages,
      MessageFilter? currentFilter,
      int? currentOffset,
      bool? maxReached,
      bool? showFilterIcon,
      String? message,
      bool? paginationLoading}) {
    return InboxMessageState(
        status: status ?? this.status,
        inboxMessages: inboxMessages ?? this.inboxMessages,
        currentFilter: currentFilter ?? this.currentFilter,
        currentOffset: currentOffset ?? this.currentOffset,
        maxReached: maxReached ?? this.maxReached,
        message: message ?? this.message,
        paginationLoading: paginationLoading ?? this.paginationLoading);
  }
}
