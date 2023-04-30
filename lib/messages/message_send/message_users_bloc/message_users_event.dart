import 'package:equatable/equatable.dart';

abstract class MessageUsersEvent extends Equatable {
  const MessageUsersEvent();
}

class MessageUsersRequested extends MessageUsersEvent {
  final String? searchParams;
  const MessageUsersRequested(this.searchParams);

  @override
  List<Object?> get props => [searchParams];
}
