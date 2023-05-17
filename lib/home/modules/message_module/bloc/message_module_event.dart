import 'package:equatable/equatable.dart';

abstract class MessageModuleEvent extends Equatable {
  const MessageModuleEvent();
}

class CoursesRequested extends MessageModuleEvent {
  @override
  List<Object?> get props => [];
}
