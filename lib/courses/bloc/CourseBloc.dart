import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:studipadawan/courses/bloc/courses_event.dart';
import 'package:studipadawan/courses/bloc/courses_state.dart';
import '../models/models.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final CourseRepository _courseRepository;

  CourseBloc({required CourseRepository courseRepository})
      : _courseRepository = courseRepository,
        super(const CourseState.initial()) {
    on<CoursesRequested>(_onCourseRequested);
  }

  FutureOr<void> _onCourseRequested(
      CoursesRequested event, Emitter<CourseState> emit) async {
    emit(state.copyWith(status: CourseStatus.loading, semesters: []));

    final semesters =
        (await _courseRepository.getCoursesGroupedBySemester(event.userId))
            .map((repositorySemester) {
      final courses = repositorySemester.courses
          .map((repositoryCourse) => Course(
              repositoryCourse: repositoryCourse, onCourseSelection: () {}))
          .toList();

      return Semester(repositorySemester: repositorySemester, courses: courses);
    }).toList();
    emit(CourseState(status: CourseStatus.populated, semesters: semesters));
  }
}
