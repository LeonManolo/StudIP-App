part of 'course_details_bloc.dart';

class CourseDetailsSelectTabEvent extends Equatable {

  const CourseDetailsSelectTabEvent({required this.selectedTab});
  final CourseDetailsTab selectedTab;

  @override
  List<Object> get props => [selectedTab];
}
