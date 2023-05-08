import 'package:equatable/equatable.dart';

abstract class OutboxMessageEvent extends Equatable {
  const OutboxMessageEvent();
}

class OutboxMessagesRequested extends OutboxMessageEvent {
  const OutboxMessagesRequested({required this.offset});
  final int offset;

  @override
  List<Object?> get props => [offset];
}

class DeleteOutboxMessagesRequested extends OutboxMessageEvent {

  const DeleteOutboxMessagesRequested({required this.messageIds});
  final List<String> messageIds;

  @override
  List<Object?> get props => [messageIds];
}

class RefreshOutboxRequested extends OutboxMessageEvent {
  const RefreshOutboxRequested();

  @override
  List<Object?> get props => [];
}
