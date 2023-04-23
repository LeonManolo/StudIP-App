import 'package:equatable/equatable.dart';

abstract class OutboxMessageEvent extends Equatable {
  const OutboxMessageEvent();
}
class OutboxMessagesRequested extends OutboxMessageEvent {

  const OutboxMessagesRequested();

  @override
  List<Object?> get props => [];
}
