import 'package:equatable/equatable.dart';


sealed class MessageDetailsState extends Equatable {
  const MessageDetailsState();

  @override
  List<Object?> get props => [];
}

class MessageDetailsStateInitial extends MessageDetailsState {
  const MessageDetailsStateInitial();

  @override
  List<Object?> get props => [];
}

class MessageDetailsStateLoading extends MessageDetailsState {
  const MessageDetailsStateLoading();

  @override
  List<Object?> get props => [];
}

class MessageDetailsStateDeleteSucceed extends MessageDetailsState {
  const MessageDetailsStateDeleteSucceed({
    required this.successInfo
  });
  final String successInfo;

  @override
  List<Object?> get props => [successInfo];
}

class MessageDetailsStateDeleteError extends MessageDetailsState {
  const MessageDetailsStateDeleteError({
    required this.failureInfo,
  });
  final String failureInfo;

  @override
  List<Object?> get props => [failureInfo];
}
