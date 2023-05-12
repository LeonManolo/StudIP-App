import 'package:equatable/equatable.dart';
import 'package:messages_repository/messages_repository.dart';

enum MessageSendStatus {
  initial,
  loading,
  recipientsChanged,
  userSuggestionsFetched,
  userSuggestionsFailed,
  populated,
  failure
}

class MessageSendState extends Equatable {
  const MessageSendState({
    required this.status,
    this.blocResponse = '',
    this.suggestions = const [],
    this.recipients = const [],
  });

  const MessageSendState.initial()
      : this(
          status: MessageSendStatus.initial,
        );

  final MessageSendStatus status;
  final String blocResponse;
  final List<MessageUser> recipients;
  final List<MessageUser> suggestions;

  @override
  List<Object?> get props => [status, blocResponse, recipients, suggestions];

  MessageSendState copyWith({
    MessageSendStatus? status,
    String? blocResponse,
    List<MessageUser>? recipients,
    List<MessageUser>? suggestions,
  }) {
    return MessageSendState(
      status: status ?? this.status,
      blocResponse: blocResponse ?? this.blocResponse,
      recipients: recipients ?? this.recipients,
      suggestions: suggestions ?? this.suggestions,
    );
  }
}
