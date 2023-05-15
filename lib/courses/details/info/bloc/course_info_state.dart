part of 'course_info_bloc.dart';

enum InfoType {
  general,
  events;
}

abstract class CourseInfoState extends Equatable {}

class CourseInfoPopulatedState extends CourseInfoState {
  CourseInfoPopulatedState({
    required this.generalInfoExpansionModel,
    required this.eventExpansionModel,
  });
  final GeneralInfoExpansionModel generalInfoExpansionModel;
  final CourseEventExpansionModel eventExpansionModel;

  @override
  List<Object> get props => [generalInfoExpansionModel, eventExpansionModel];
}

class CourseInfoLoadingState extends CourseInfoState {
  @override
  List<Object?> get props => [];
}
