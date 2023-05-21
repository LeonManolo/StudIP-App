import 'package:bloc/bloc.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:studipadawan/utils/throttle_droppable.dart';

part 'course_wiki_event.dart';
part 'course_wiki_state.dart';

class CourseWikiBloc extends Bloc<CourseWikiEvent, CourseWikiState> {
  CourseWikiBloc({
    required CourseRepository courseRepository,
    required this.courseId,
    this.limit = 15,
  })  : _courseRepository = courseRepository,
        super(CourseWikiStateLoading()) {
    on<CourseWikiReloadRequested>(_onCourseWikiReloadRequested);
    on<CourseWikiReachedBottom>(
      _onCourseWikiReachedBottom,
      transformer: throttleDroppable(const Duration(milliseconds: 150)),
    );
  }

  final CourseRepository _courseRepository;
  final String courseId;
  final int limit;

  Future<void> _onCourseWikiReloadRequested(
    CourseWikiReloadRequested event,
    Emitter<CourseWikiState> emit,
  ) async {
    emit(CourseWikiStateLoading());

    try {
      final response = await _courseRepository.getWikiPages(
        courseId: courseId,
        limit: limit,
        offset: 0,
      );
      emit(
        CourseWikiStateDidLoad(
          wikiPages: response.wikiPages,
          paginationLoading: false,
          maxReached:
              response.wikiPages.length >= response.totalNumberOfWikiPages,
        ),
      );
    } catch (e) {
      Logger().e(e);
      emit(
        CourseWikiStateError(
          errorMessage:
              'Beim Laden der Ankündigungen ist ein Fehler aufgetreten.',
        ),
      );
    }
  }

  Future<void> _onCourseWikiReachedBottom(
    CourseWikiReachedBottom event,
    Emitter<CourseWikiState> emit,
  ) async {
    switch (state) {
      case CourseWikiStateLoading _:
      case CourseWikiStateError _:
        return;
      case final CourseWikiStateDidLoad didLoadState:
        await _handleValidCourseWikiReachedBottom(
          state: didLoadState,
          emit: emit,
        );
        break;
    }
  }

  Future<void> _handleValidCourseWikiReachedBottom({
    required CourseWikiStateDidLoad state,
    required Emitter<CourseWikiState> emit,
  }) async {
    if (state.maxReached || state.paginationLoading) return;

    try {
      emit(
        state.copyWith(
          paginationLoading: true,
        ),
      );

      final response = await _courseRepository.getWikiPages(
        courseId: courseId,
        limit: limit,
        offset: state.wikiPages.length,
      );

      final updatedWikiPages = [...state.wikiPages, ...response.wikiPages];
      emit(
        CourseWikiStateDidLoad(
          wikiPages: updatedWikiPages,
          maxReached:
              updatedWikiPages.length >= response.totalNumberOfWikiPages,
          paginationLoading: false,
        ),
      );
    } catch (e) {
      Logger().e(e);
      emit(
        CourseWikiStateError(
          errorMessage:
              'Beim Laden der Ankündigungen ist ein Fehler aufgetreten.',
        ),
      );
    }
  }
}
