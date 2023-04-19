part of 'course_info_bloc.dart';

enum InfoType {
  general,
  news,
  events;
}

abstract class CourseInfoState extends Equatable {}

class CourseInfoPopulatedState extends CourseInfoState {
  final GeneralInfoExpansionModel generalInfoExpansionModel;
  final NewsExpansionModel newsExpansionModel;
  final CourseEventExpansionModel eventExpansionModel;

  CourseInfoPopulatedState({
    required this.generalInfoExpansionModel,
    required this.newsExpansionModel,
    required this.eventExpansionModel,
  });

  @override
  List<Object> get props =>
      [generalInfoExpansionModel, newsExpansionModel, eventExpansionModel];
}

class CourseInfoLoadingState extends CourseInfoState {
  @override
  List<Object?> get props => [];
}
