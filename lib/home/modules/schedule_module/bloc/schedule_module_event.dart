import 'package:equatable/equatable.dart';

abstract class ScheduleModuleEvent extends Equatable {
  const ScheduleModuleEvent();
}

class CoursesRequested extends ScheduleModuleEvent {
  @override
  List<Object?> get props => [];
}
