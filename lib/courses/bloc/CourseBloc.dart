import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:studipadawan/courses/bloc/courses_event.dart';
import 'package:studipadawan/courses/bloc/courses_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final CourseRepository _courseRepository;

  CourseBloc({required CourseRepository courseRepository})
      : _courseRepository = courseRepository,
        super(const CourseState.initial()) {
    on<CoursesRequested>(_onCourseRequested);
  }

  FutureOr<void> _onCourseRequested(
      CoursesRequested event, Emitter<CourseState> emit) async {
    emit(state.copyWith(status: CourseStatus.loading, courses: []));
    final courses = await _courseRepository.getCourses(event.userId);
    emit(CourseState(status: CourseStatus.populated, courses: courses));
  }
}
