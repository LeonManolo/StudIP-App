import 'package:equatable/equatable.dart';

abstract class CourseEvent extends Equatable {
  const CourseEvent();
}

class CoursesRequested extends CourseEvent {
  @override
  List<Object?> get props => [];
}
