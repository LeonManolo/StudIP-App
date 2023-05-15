import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:equatable/equatable.dart';

part 'course_news_event.dart';
part 'course_news_state.dart';

class CourseNewsBloc extends Bloc<CourseNewsEvent, CourseNewsState> {
  CourseNewsBloc({
    required CourseRepository courseRepository,
    required this.courseId,
  })  : _courseRepository = courseRepository,
        super(CourseNewsIsLoading()) {
    on<CourseNewsReloadRequested>(_onCourseNewsReloadRequested);
  }

  final CourseRepository _courseRepository;
  final String courseId;

  FutureOr<void> _onCourseNewsReloadRequested(
      CourseNewsReloadRequested event, Emitter<CourseNewsState> emit) async {
    emit(CourseNewsIsLoading());

    try {
      final List<CourseNews> news =
          await _courseRepository.getCourseNews(courseId: courseId, limit: 5);
      emit(CourseNewsDidLoad(news: news));
    } catch (_) {
      emit(
        const CourseNewsError(
          errorMessage:
              'Es ist ein Fehler aufgetreten. Bitte versuchen Sie es erneut',
        ),
      );
    }
  }
}
