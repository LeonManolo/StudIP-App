
import 'package:equatable/equatable.dart';

abstract class CourseEvent extends Equatable {
  const CourseEvent();
}

class CoursesRequested extends CourseEvent {
  final String userId;

  const CoursesRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}

