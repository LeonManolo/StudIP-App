import 'package:equatable/equatable.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();
}

class RefreshRequested extends MessageEvent {
  
  const RefreshRequested();

  @override
  List<Object?> get props => [];
}

class FilterhRequested extends MessageEvent {
  
  const FilterhRequested();

  @override
  List<Object?> get props => [];
}

class InboxOutboxToggleBoxDidChange extends MessageEvent {
  final int index;

  const InboxOutboxToggleBoxDidChange(
      {required this.index});

  @override
  List<Object?> get props => [index];
}

