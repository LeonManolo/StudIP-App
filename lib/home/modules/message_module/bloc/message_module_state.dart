import 'package:equatable/equatable.dart';

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
  const MessageModuleStateDidLoad();

  @override
  List<Object?> get props => [];

  MessageModuleStateDidLoad copyWith() {
    return const MessageModuleStateDidLoad();
  }
}

class MessageModuleStateError extends MessageModuleState {
  const MessageModuleStateError();

  @override
  List<Object?> get props => [];

  MessageModuleStateError copyWith() {
    return const MessageModuleStateError();
  }
}
