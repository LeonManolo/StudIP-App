import 'package:equatable/equatable.dart';

import 'message_state.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();
}

class RefreshRequested extends MessageEvent {
  final MessageFilter filter;

  const RefreshRequested({required this.filter});

  @override
  List<Object?> get props => [filter];
}

class InboxOutboxToggleBoxDidChange extends MessageEvent {
  final int index;
  final MessageFilter filter;

  const InboxOutboxToggleBoxDidChange(
      {required this.index, required this.filter});

  @override
  List<Object?> get props => [index];
}
