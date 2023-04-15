import 'package:equatable/equatable.dart';

import 'message_state.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();
}

class RefreshRequested extends MessageEvent {
  final MessageFilter filter;
  final bool isInbox;

  const RefreshRequested({required this.filter, required this.isInbox});

  @override
  List<Object?> get props => [filter, isInbox];
}
