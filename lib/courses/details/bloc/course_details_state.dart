part of 'course_details_bloc.dart';

enum CourseDetailsTab {
  info("Info", Icons.info_outline),
  files("Dateien", Icons.folder_outlined),
  participants("Teilnehmer", Icons.person_outlined),
  forum("Forum", Icons.message);

  final String title;
  final IconData icon;

  const CourseDetailsTab(this.title, this.icon);
}

class CourseDetailsState extends Equatable {
  final CourseDetailsTab selectedTab;
  final Course course;

  const CourseDetailsState({required this.selectedTab, required this.course});

  const CourseDetailsState.initial({required Course course})
      : this(selectedTab: CourseDetailsTab.info, course: course);

  @override
  List<Object> get props => [selectedTab, course];
}
