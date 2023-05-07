part of 'course_details_bloc.dart';

enum CourseDetailsTab {
  info('Info', Icons.info_outline),
  files('Dateien', Icons.folder_outlined),
  participants('Teilnehmer', Icons.person_outlined),
  forum('Forum', Icons.message_outlined);

  const CourseDetailsTab(this.title, this.icon);

  final String title;
  final IconData icon;
}

class CourseDetailsState extends Equatable {
  const CourseDetailsState({required this.selectedTab, required this.course});

  const CourseDetailsState.initial({required Course course})
      : this(selectedTab: CourseDetailsTab.info, course: course);
  final CourseDetailsTab selectedTab;
  final Course course;

  @override
  List<Object> get props => [selectedTab, course];
}
