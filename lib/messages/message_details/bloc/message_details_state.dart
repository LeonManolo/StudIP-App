import 'package:equatable/equatable.dart';


sealed class MessageDetailState extends Equatable {
  const MessageDetailState();

  @override
  List<Object?> get props => [];
}

class MessageDetailStateInitial extends MessageDetailState {
  const MessageDetailStateInitial();

  @override
  List<Object?> get props => [];
}

class MessageDetailStateLoading extends MessageDetailState {
  const MessageDetailStateLoading();

  @override
  List<Object?> get props => [];
}

class MessageDetailStateDeleteMessageSucceed extends MessageDetailState {
  const MessageDetailStateDeleteMessageSucceed({
    required this.blocResponse,
  });
  final String blocResponse;

  @override
  List<Object?> get props => [blocResponse];
}

class MessageDetailStateDeleteMessageError extends MessageDetailState {
  const MessageDetailStateDeleteMessageError({
    required this.blocResponse,
  });
  final String blocResponse;

  @override
  List<Object?> get props => [blocResponse];
}
