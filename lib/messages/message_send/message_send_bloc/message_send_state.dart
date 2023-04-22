import 'package:equatable/equatable.dart';

enum MessageSendStatus {
  initial,
  loading,
  populated,
  failure

}

class MessageSendState extends Equatable {
  final MessageSendStatus status;
  final String errorMessage;

  const MessageSendState({
    required this.status,
    this.errorMessage = ""
  });

  const MessageSendState.initial()
      : this(
          status: MessageSendStatus.initial,
        );

  @override
  List<Object?> get props => [
        status, errorMessage
      ];

  MessageSendState copyWith({
    MessageSendStatus? status,
    String? errorMessage
    }) {
    return MessageSendState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage
      );
  }
}
