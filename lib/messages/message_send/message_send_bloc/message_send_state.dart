import 'package:equatable/equatable.dart';
import 'package:messages_repository/messages_repository.dart';

enum MessageSendStatus {
  initial,
  loading,
  recipientAdded,
  recipientRemoved,
  populated,
  failure
}

class MessageSendState extends Equatable {
  const MessageSendState({
    required this.status,
    this.blocResponse = '',
    this.recipients = const [],
  });

  const MessageSendState.initial()
      : this(
          status: MessageSendStatus.initial,
        );

  final MessageSendStatus status;
  final String blocResponse;
  final List<MessageUser> recipients;

  @override
  List<Object?> get props => [status, blocResponse, recipients];

  MessageSendState copyWith({
    MessageSendStatus? status,
    String? blocResponse,
    List<MessageUser>? recipients,
  }) {
    return MessageSendState(
      status: status ?? this.status,
      blocResponse: blocResponse ?? this.blocResponse,
      recipients: recipients ?? this.recipients,
    );
  }
}
