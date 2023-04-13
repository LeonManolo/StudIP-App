import 'package:equatable/equatable.dart';
import 'package:messages_repository/messages_repository.dart';

enum MessageStatus {
  initial,
  loading,
  populated,
  failure,
}

enum MessageFilter { none, read, unread }

class MessageState extends Equatable {
  final MessageStatus status;
  final List<Message> messages;
  final List<bool> toggleBoxStates;
  final List<String> toggleBoxLabels = const ["Inbox", "Outbox"];
  final MessageFilter filter;

  bool get isInbox {
    return toggleBoxStates.first;
  }

  const MessageState(
      {required this.status,
      this.messages = const [],
      this.toggleBoxStates = const [true, false],
      this.filter = MessageFilter.none});

  const MessageState.initial()
      : this(
          status: MessageStatus.initial,
        );

  @override
  List<Object?> get props => [status, messages];

  MessageState copyWith({
    MessageStatus? status,
    List<Message>? messages,
    List<bool>? toggleBoxStates,
    MessageFilter? filter,
  }) {
    return MessageState(
        status: status ?? this.status,
        messages: messages ?? this.messages,
        toggleBoxStates: toggleBoxStates ?? this.toggleBoxStates,
        filter: filter ?? this.filter);
  }
}
