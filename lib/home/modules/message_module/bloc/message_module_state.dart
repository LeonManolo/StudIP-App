import 'package:equatable/equatable.dart';
import 'package:messages_repository/messages_repository.dart';

sealed class MessageModuleState extends Equatable {
  const MessageModuleState();

  @override
  List<Object?> get props => [];
}

class MessageModuleStateInitial extends MessageModuleState {
  const MessageModuleStateInitial();

  @override
  List<Object?> get props => [];
}

class MessageModuleStateLoading extends MessageModuleState {
  const MessageModuleStateLoading();

  @override
  List<Object?> get props => [];
}

class MessageModuleStateDidLoad extends MessageModuleState {
  const MessageModuleStateDidLoad({
    this.previewMessages = const [],
  });
  final List<Message> previewMessages;

  @override
  List<Object?> get props => [previewMessages];
}

class MessageModuleStateError extends MessageModuleState {
  const MessageModuleStateError();
  @override
  List<Object?> get props => [];
}
