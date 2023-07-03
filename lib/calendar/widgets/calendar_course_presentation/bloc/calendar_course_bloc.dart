import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

part 'calendar_course_event.dart';
part 'calendar_course_state.dart';

class CalendarCourseBloc
    extends Bloc<CalendarCourseEvent, CalendarCourseState> {
  CalendarCourseBloc({
    required CourseRepository courseRepository,
    required String courseId,
  })  : _courseRepository = courseRepository,
        _courseId = courseId,
        super(CalendarCourseStateLoading()) {
    on<CalendarCourseRequested>(_onCourseRequested);
  }

  final CourseRepository _courseRepository;
  final String _courseId;

  FutureOr<void> _onCourseRequested(
    CalendarCourseRequested event,
    Emitter<CalendarCourseState> emit,
  ) async {
    emit(CalendarCourseStateLoading());

    try {
      final course = await _courseRepository.getCourse(courseId: _courseId);
      emit(CalendarCourseStateCourseDidLoad(course: course));
    } catch (e) {
      Logger().e(e);
      emit(
        const CalendarCourseStateError(
          errorMessage: 'Der gewünschte Kurs konnte nicht geladen werden',
        ),
      );
    }
  }
}
