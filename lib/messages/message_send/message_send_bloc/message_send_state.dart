import 'package:equatable/equatable.dart';

enum MessageSendStatus {
  initial,
  loading,
  populated,
  failure

}

class MessageSendState extends Equatable {

  const MessageSendState({
    required this.status,
    this.message = '',
  });

  const MessageSendState.initial()
      : this(
          status: MessageSendStatus.initial,
        );
  final MessageSendStatus status;
  final String message;

  @override
  List<Object?> get props => [
        status, message
      ];

  MessageSendState copyWith({
    MessageSendStatus? status,
    String? message,
    }) {
    return MessageSendState(
      status: status ?? this.status,
      message: message ?? this.message,
      );
  }
}
