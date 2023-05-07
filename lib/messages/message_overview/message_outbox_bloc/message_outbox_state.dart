import 'package:equatable/equatable.dart';
import 'package:messages_repository/messages_repository.dart';

enum OutboxMessageStatus {
  initial,
  loading,
  paginationLoading,
  deleteOutboxMessagesSucceed,
  deleteOutboxMessagesFailure,
  populated,
  failure,
}

class OutboxMessageState extends Equatable {

  const OutboxMessageState(
      {required this.status,
      this.outboxMessages = const [],
      this.currentOffset = 0,
      this.message = '',
      this.maxReached = false,
      this.paginationLoading = false,});

  const OutboxMessageState.initial()
      : this(
          status: OutboxMessageStatus.initial,
        );
  final OutboxMessageStatus status;
  final List<Message> outboxMessages;
  final int currentOffset;
  final bool maxReached;
  final String message;
  final bool paginationLoading;

  @override
  List<Object?> get props =>
      [status, outboxMessages, currentOffset, maxReached, message, paginationLoading];

  OutboxMessageState copyWith(
      {OutboxMessageStatus? status,
      List<Message>? outboxMessages,
      int? currentOffset,
      String? message,
      bool? maxReached,
      bool? paginationLoading,}) {
    return OutboxMessageState(
        status: status ?? this.status,
        outboxMessages: outboxMessages ?? this.outboxMessages,
        currentOffset: currentOffset ?? this.currentOffset,
        message: message ?? this.message,
        maxReached: maxReached ?? this.maxReached,
        paginationLoading: paginationLoading ?? this.paginationLoading,);
  }
}
