import 'package:equatable/equatable.dart';

abstract class MessageDetailsEvent extends Equatable {
  const MessageDetailsEvent();
}


class DeleteMessageRequested extends MessageDetailsEvent {
  final String messageId;
  const DeleteMessageRequested({required this.messageId});

  @override
  List<Object?> get props => [messageId];
}

