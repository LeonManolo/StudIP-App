part of 'course_details_bloc.dart';

class CourseDetailsSelectTabEvent extends Equatable {
  final CourseDetailsTab selectedTab;

  const CourseDetailsSelectTabEvent({required this.selectedTab});

  @override
  List<Object> get props => [selectedTab];
}
