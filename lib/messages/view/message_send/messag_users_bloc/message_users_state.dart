import 'package:equatable/equatable.dart';
import 'package:messages_repository/messages_repository.dart';

enum MessageUserState {
  initial,
  loading,
  populated,
  failure,
}

class MessageUsersState extends Equatable {
  final MessageUserState status;
  final List<User>? users;

  const MessageUsersState({
    required this.status,
    this.users = const []
  });

  const MessageUsersState.initial()
      : this(
          status: MessageUserState.initial,
        );

  @override
  List<Object?> get props => [
        status, users
      ];

  MessageUsersState copyWith({
    MessageUserState? status,
    List<User>? users
    }) {
    return MessageUsersState(
      status: status ?? this.status,
      users: users ?? this.users
      );
  }
}
