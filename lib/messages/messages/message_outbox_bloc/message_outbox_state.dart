import 'package:equatable/equatable.dart';
import 'package:messages_repository/messages_repository.dart';

enum OutboxMessageStatus {
  initial,
  loading,
  populated,
  failure,
}

class OutboxMessageState extends Equatable {
  final OutboxMessageStatus status;
  final List<Message> outboxMessages;

  const OutboxMessageState(
      {required this.status,
      this.outboxMessages = const [],
      });

  const OutboxMessageState.initial()
      : this(
          status: OutboxMessageStatus.initial,
        );

  @override
  List<Object?> get props => [status, outboxMessages];

  OutboxMessageState copyWith({
    OutboxMessageStatus? status,
    List<Message>? outboxMessages,
  }) {
    return OutboxMessageState(
        status: status ?? this.status,
        outboxMessages: outboxMessages ?? this.outboxMessages);
  }
}
