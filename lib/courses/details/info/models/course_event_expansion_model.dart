import 'package:courses_repository/courses_repository.dart';

class CourseEventExpansionModel {
  final List<StudIPCourseEvent> events;
  bool isExpanded;

  CourseEventExpansionModel({required this.events, this.isExpanded = false});

  CourseEventExpansionModel copyWith(
      {List<StudIPCourseEvent>? events, bool? isExpanded}) {
    return CourseEventExpansionModel(
      events: events ?? this.events,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}
