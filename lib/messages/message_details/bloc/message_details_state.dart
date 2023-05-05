import 'package:equatable/equatable.dart';

enum MessageDetailsStatus {
  initial,
  loading,
  deleteMessageSucceed,
  deleteMessageFailure,
}

class MessageDetailsState extends Equatable {
  final MessageDetailsStatus status;
  final String message;
  
  const MessageDetailsState(
      {required this.status,
      this.message = "",});

  const MessageDetailsState.initial()
      : this(
          status: MessageDetailsStatus.initial,
        );

  @override
  List<Object?> get props => [
        status,
        message,
      ];

  MessageDetailsState copyWith(
      {MessageDetailsStatus? status,
      String? message}) {
    return MessageDetailsState(
        status: status ?? this.status,
        message: message ?? this.message);
  }
}
