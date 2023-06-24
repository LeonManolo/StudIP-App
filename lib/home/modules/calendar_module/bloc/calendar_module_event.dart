import 'package:equatable/equatable.dart';

abstract class CalendarModuleEvent extends Equatable {
  const CalendarModuleEvent();
}

class CalendarPreviewRequested extends CalendarModuleEvent {
  const CalendarPreviewRequested();

  @override
  List<Object?> get props => [];
}
