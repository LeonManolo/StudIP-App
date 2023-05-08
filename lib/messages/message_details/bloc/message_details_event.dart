import 'package:equatable/equatable.dart';

abstract class MessageDetailsEvent extends Equatable {
  const MessageDetailsEvent();
}

class DeleteMessageRequested extends MessageDetailsEvent {
  const DeleteMessageRequested({required this.messageId});
  final String messageId;

  @override
  List<Object?> get props => [messageId];
}
