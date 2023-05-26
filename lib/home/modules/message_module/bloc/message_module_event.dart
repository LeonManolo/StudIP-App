import 'package:equatable/equatable.dart';

abstract class MessageModuleEvent extends Equatable {
  const MessageModuleEvent();
}

class MessagePreviewRequested extends MessageModuleEvent {
  const MessagePreviewRequested();

  @override
  List<Object?> get props => [];
}
