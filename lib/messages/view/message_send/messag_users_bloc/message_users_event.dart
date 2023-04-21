import 'package:equatable/equatable.dart';

abstract class MessageUsersEvent extends Equatable {
  const MessageUsersEvent();
}

class MessageUsersRequested extends MessageUsersEvent {

  const MessageUsersRequested();

  @override
  List<Object?> get props => [];
}
