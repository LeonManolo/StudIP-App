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

class RefreshOutboxRequested extends OutboxMessageEvent {
  const RefreshOutboxRequested();

  @override
  List<Object?> get props => [];
}
