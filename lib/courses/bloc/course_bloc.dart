import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:studipadawan/courses/bloc/courses_event.dart';
import 'package:studipadawan/courses/bloc/courses_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final CourseRepository _courseRepository;
  final AuthenticationRepository _authenticationRepository;

  CourseBloc(
      {required CourseRepository courseRepository,
      required AuthenticationRepository authenticationRepository})
      : _courseRepository = courseRepository,
        _authenticationRepository = authenticationRepository,
        super(const CourseState.initial()) {
    on<CoursesRequested>(_onCourseRequested);
  }

  FutureOr<void> _onCourseRequested(
      CoursesRequested event, Emitter<CourseState> emit) async {
    emit(state.copyWith(status: CourseStatus.loading, semesters: []));

    try {
      final semesters = (await _courseRepository.getCoursesGroupedBySemester(
          _authenticationRepository.currentUser.id));

      emit(CourseState(status: CourseStatus.populated, semesters: semesters));
    } catch (e) {
      emit(const CourseState(status: CourseStatus.failure));
    }
  }
}
