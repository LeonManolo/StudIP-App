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
  none('Alle Nachrichten'),
  unread('Ungelesene Nachrichten');

  const MessageFilter(this.description);
  final String description;
}

class InboxMessageState extends Equatable {
  const InboxMessageState({
    required this.status,
    this.inboxMessages = const [],
    this.currentFilter = MessageFilter.none,
    this.blocResponse = '',
    this.currentOffset = 0,
    this.maxReached = false,
    this.paginationLoading = false,
  });

  const InboxMessageState.initial()
      : this(
          status: InboxMessageStatus.initial,
        );
  final InboxMessageStatus status;
  final String blocResponse;
  final List<Message> inboxMessages;
  final MessageFilter currentFilter;
  final int currentOffset;
  final bool maxReached;
  final bool paginationLoading;

  @override
  List<Object?> get props => [
        status,
        inboxMessages,
        currentFilter,
        currentOffset,
        maxReached,
        blocResponse,
        paginationLoading,
      ];

  InboxMessageState copyWith({
    InboxMessageStatus? status,
    List<Message>? inboxMessages,
    MessageFilter? currentFilter,
    int? currentOffset,
    bool? maxReached,
    bool? showFilterIcon,
    String? blocResponse,
    bool? paginationLoading,
  }) {
    return InboxMessageState(
      status: status ?? this.status,
      inboxMessages: inboxMessages ?? this.inboxMessages,
      currentFilter: currentFilter ?? this.currentFilter,
      currentOffset: currentOffset ?? this.currentOffset,
      maxReached: maxReached ?? this.maxReached,
      blocResponse: blocResponse ?? this.blocResponse,
      paginationLoading: paginationLoading ?? this.paginationLoading,
    );
  }
}
