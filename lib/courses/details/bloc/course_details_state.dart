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

  const CourseDetailsState({required this.selectedTab});

  const CourseDetailsState.initial() : this(selectedTab: CourseDetailsTab.info);

  @override
  List<Object> get props => [selectedTab];
}
