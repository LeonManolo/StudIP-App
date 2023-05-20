import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:studipadawan/utils/throttle_droppable.dart';

part 'course_news_event.dart';
part 'course_news_state.dart';

class CourseNewsBloc extends Bloc<CourseNewsEvent, CourseNewsState> {
  CourseNewsBloc({
    required CourseRepository courseRepository,
    required this.courseId,
    this.limit = 10,
  })  : _courseRepository = courseRepository,
        super(CourseNewsStateLoading()) {
    on<CourseNewsReloadRequested>(_onCourseNewsReloadRequested);
    on<CourseNewsReachedBottom>(
      _onCourseNewsReachedBottom,
      transformer: throttleDroppable(const Duration(milliseconds: 150)),
    );
  }

  final CourseRepository _courseRepository;
  final String courseId;
  final int limit;

  Future<void> _onCourseNewsReloadRequested(
    CourseNewsReloadRequested event,
    Emitter<CourseNewsState> emit,
  ) async {
    emit(CourseNewsStateLoading());

    try {
      final response = await _courseRepository.getCourseNews(
        courseId: courseId,
        limit: limit,
        offset: 0,
      );
      emit(
        CourseNewsStateDidLoad(
          news: response.news,
          paginationLoading: false,
          maxReached: response.news.length >= response.totalNumberOfNews,
        ),
      );
    } catch (e) {
      Logger().e(e);
      emit(
        CourseNewsStateError(
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
    switch (state) {
      case CourseNewsStateLoading _:
        return;
      case CourseNewsStateError _:
        return;
      case final CourseNewsStateDidLoad didLoadState:
        await _handleValidCourseNewsReachedBottom(
          state: didLoadState,
          emit: emit,
        );
        break;
    }
  }

  Future<void> _handleValidCourseNewsReachedBottom({
    required CourseNewsStateDidLoad state,
    required Emitter<CourseNewsState> emit,
  }) async {
    if (state.maxReached || state.paginationLoading) return;

    try {
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
          paginationLoading: false,
          news: updatedNews,
        ),
      );
    } catch (e) {
      Logger().e(e);
      emit(
        CourseNewsStateError(
          errorMessage:
              'Beim Laden der Ankündigungen ist ein Fehler aufgetreten.',
        ),
      );
    }
  }
}
