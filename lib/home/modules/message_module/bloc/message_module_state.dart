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

  MessageModuleStateInitial copyWith() {
    return const MessageModuleStateInitial();
  }
}

class MessageModuleStateLoading extends MessageModuleState {
  const MessageModuleStateLoading();

  @override
  List<Object?> get props => [];

  MessageModuleStateLoading copyWith() {
    return const MessageModuleStateLoading();
  }
}

class MessageModuleStateDidLoad extends MessageModuleState {
  const MessageModuleStateDidLoad({
    this.previewMessages = const [],
  });
  final List<Message> previewMessages;

  @override
  List<Object?> get props => [previewMessages];

  MessageModuleStateDidLoad copyWith({List<Message>? previewMessages}) {
    return MessageModuleStateDidLoad(
      previewMessages: previewMessages ?? this.previewMessages,
    );
  }
}

class MessageModuleStateError extends MessageModuleState {
  const MessageModuleStateError({
    this.blocResponse = '',
  });
  final String blocResponse;
  @override
  List<Object?> get props => [];

  MessageModuleStateError copyWith() {
    return const MessageModuleStateError();
  }
}
