import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

part 'course_news_event.dart';
part 'course_news_state.dart';

// https://bloclibrary.dev/#/flutterinfinitelisttutorial?id=post-bloc
const throttleDuration = Duration(milliseconds: 150);
EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class CourseNewsBloc extends Bloc<CourseNewsEvent, CourseNewsState> {
  CourseNewsBloc({
    required CourseRepository courseRepository,
    required this.courseId,
  })  : _courseRepository = courseRepository,
        super(CourseNewsState.inital()) {
    on<CourseNewsReloadRequested>(_onCourseNewsReloadRequested);
    on<CourseNewsReachedBottom>(
      _onCourseNewsReachedBottom,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final CourseRepository _courseRepository;
  final String courseId;
  final int limit = 7;

  Future<void> _onCourseNewsReloadRequested(
    CourseNewsReloadRequested event,
    Emitter<CourseNewsState> emit,
  ) async {
    emit(state.copyWith(status: CourseNewsStatus.isLoading));

    try {
      final response = await _courseRepository.getCourseNews(
        courseId: courseId,
        limit: limit,
        offset: 0,
      );
      emit(
        state.copyWith(
          news: response.news,
          status: CourseNewsStatus.didLoad,
          maxReached: response.news.length >= response.totalNumberOfNews,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: CourseNewsStatus.error,
          errorMessage:
              'Beim Laden der Ankündigungen ist ein Fehler aufgetreten.',
        ),
      );
    }
  }

  Future<void> _onCourseNewsReachedBottom(
    CourseNewsReachedBottom event,
    Emitter<CourseNewsState> emit,
  ) async {
    if (state.maxReached || state.paginationLoading) return;

    try {
      if (state.news.isEmpty) {
        emit(
          state.copyWith(
            status: CourseNewsStatus.isLoading,
            paginationLoading: false,
          ),
        );
        final response = await _courseRepository.getCourseNews(
          courseId: courseId,
          limit: limit,
          offset: 0,
        );
        emit(
          state.copyWith(
            status: CourseNewsStatus.didLoad,
            news: response.news,
          ),
        );
      } else {
        emit(
          state.copyWith(
            paginationLoading: true,
          ),
        );

        final response = await _courseRepository.getCourseNews(
          courseId: courseId,
          limit: limit,
          offset: state.news.length,
        );

        final updatedNews = [...state.news, ...response.news];
        emit(
          state.copyWith(
            maxReached: updatedNews.length >= response.totalNumberOfNews,
            status: CourseNewsStatus.didLoad,
            paginationLoading: false,
            news: updatedNews,
          ),
        );
      }
    } catch (_) {
      emit(
        state.copyWith(
          status: CourseNewsStatus.error,
          errorMessage:
              'Beim Laden der Ankündigungen ist ein Fehler aufgetreten',
        ),
      );
    }
  }
}
