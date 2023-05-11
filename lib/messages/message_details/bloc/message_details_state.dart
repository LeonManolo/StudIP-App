import 'package:equatable/equatable.dart';

enum MessageDetailsStatus {
  initial,
  loading,
  deleteMessageSucceed,
  deleteMessageFailure,
}

class MessageDetailsState extends Equatable {
  const MessageDetailsState({
    required this.status,
    this.blocResponse = '',
  });

  const MessageDetailsState.initial()
      : this(
          status: MessageDetailsStatus.initial,
        );
  final MessageDetailsStatus status;
  final String blocResponse;

  @override
  List<Object?> get props => [
        status,
        blocResponse,
      ];

  MessageDetailsState copyWith({
    MessageDetailsStatus? status,
    String? blocResponse,
  }) {
    return MessageDetailsState(
      status: status ?? this.status,
      blocResponse: blocResponse ?? this.blocResponse,
    );
  }
}
