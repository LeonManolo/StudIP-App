import 'package:courses_repository/courses_repository.dart';

class CourseEventExpansionModel {

  CourseEventExpansionModel({required this.events, this.isExpanded = false});
  final List<StudIPCourseEvent> events;
  bool isExpanded;

  CourseEventExpansionModel copyWith(
      {List<StudIPCourseEvent>? events, bool? isExpanded,}) {
    return CourseEventExpansionModel(
      events: events ?? this.events,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}
