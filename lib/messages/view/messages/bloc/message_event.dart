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


class ReadMessageRequested extends MessageEvent {
  final String messageId;

  const ReadMessageRequested({required this.messageId});

  @override
  List<Object?> get props => [messageId];
}
