import 'package:equatable/equatable.dart';

abstract class OutboxMessageEvent extends Equatable {
  const OutboxMessageEvent();
}

class OutboxMessagesRequested extends OutboxMessageEvent {
  final int offset;
  const OutboxMessagesRequested({required this.offset});

  @override
  List<Object?> get props => [offset];
}

class DeleteOutboxMessagesRequested extends OutboxMessageEvent {
  final List<String> messageIds;

  const DeleteOutboxMessagesRequested({required this.messageIds});

  @override
  List<Object?> get props => [messageIds];
}

class RefreshOutboxRequested extends OutboxMessageEvent {
  const RefreshOutboxRequested();

  @override
  List<Object?> get props => [];
}
