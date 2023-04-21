import 'package:equatable/equatable.dart';

enum MessageSendStatus {
  initial,
  loading,
  populated,
  failure,
}

class MessageSendState extends Equatable {
  final MessageSendStatus status;

  const MessageSendState({
    required this.status,
  });

  const MessageSendState.initial()
      : this(
          status: MessageSendStatus.initial,
        );

  @override
  List<Object?> get props => [
        status,
      ];

  MessageSendState copyWith({MessageSendStatus? status}) {
    return MessageSendState(status: status ?? this.status);
  }
}
