part of 'course_info_bloc.dart';

abstract class CourseInfoEvent extends Equatable {
  const CourseInfoEvent();

  @override
  List<Object> get props => [];
}

class ToggleSectionEvent extends CourseInfoEvent {
  final InfoType type;
  final bool newExpansionState;

  const ToggleSectionEvent(
      {required this.type, required this.newExpansionState});

  @override
  List<Object> get props => [type, newExpansionState];
}

class TriggerInitialLoadEvent extends CourseInfoEvent {}
