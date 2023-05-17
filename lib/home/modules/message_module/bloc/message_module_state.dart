import 'package:equatable/equatable.dart';

enum MessageModuleStatus {
  initial,
  loading,
  populated,
  failure,
}

class MessageModuleState extends Equatable {
  const MessageModuleState({
    required this.status,
  });

  const MessageModuleState.initial()
      : this(
          status: MessageModuleStatus.initial,
        );
  final MessageModuleStatus status;

  @override
  List<Object?> get props => [status];

  MessageModuleState copyWith({MessageModuleStatus? status}) {
    return MessageModuleState(
      status: status ?? this.status,
    );
  }
}
