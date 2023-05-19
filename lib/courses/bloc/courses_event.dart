import 'package:equatable/equatable.dart';
import 'package:studipadawan/courses/bloc/courses_state.dart';

abstract class CourseEvent extends Equatable {
  const CourseEvent();
}

class CoursesRequested extends CourseEvent {
  @override
  List<Object?> get props => [];
}

class SemesterFilterChanged extends CourseEvent {
  const SemesterFilterChanged({required this.selectedSemesterFilter});

  final SemesterFilter selectedSemesterFilter;

  @override
  List<Object?> get props => [selectedSemesterFilter];
}

class SemesterSortOrderChanged extends CourseEvent {
  const SemesterSortOrderChanged({required this.selectedSemesterSortOrder});

  final SemesterSortOrder selectedSemesterSortOrder;

  @override
  List<Object?> get props => [selectedSemesterSortOrder];
}
