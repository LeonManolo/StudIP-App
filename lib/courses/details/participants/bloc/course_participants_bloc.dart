import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:studipadawan/utils/throttle_droppable.dart';

part 'course_participants_event.dart';

part 'course_participants_state.dart';

class CourseParticipantsBloc
    extends Bloc<CourseParticipantsEvent, CourseParticipantsState> {
  CourseParticipantsBloc({
    required CourseRepository courseRepository,
    required this.courseId,
    this.limit = 10,
  })  : _courseRepository = courseRepository,
        super(const CourseParticipantsInitial()) {
    on<CourseParticipantsRequested>(_onCourseParticipantsRequested);
    on<CourseParticipantsReachedBottom>(
      _onCourseParticipantsReachedBottom,
      transformer: throttleDroppable(const Duration(milliseconds: 150)),
    );
  }

  final CourseRepository _courseRepository;
  final String courseId;
  final int limit;

  FutureOr<void> _onCourseParticipantsRequested(
    CourseParticipantsRequested event,
    Emitter<CourseParticipantsState> emit,
  ) async {
    emit(const CourseParticipantsLoading());

    try {
      final response = await _courseRepository.getCourseParticipants(
        courseId: courseId,
        offset: 0,
        limit: limit,
      );

      emit(
        CourseParticipantsDidLoad(
          participants: response.participants,
          maxReached:
              response.participants.length >= response.totalParticipants,
          paginationLoading: false,
        ),
      );
    } catch (e) {
      Logger().e(e);
      emit(
        const CourseParticipantsError(
          errorMessage: 'Beim Laden der Teilnehmer ist ein Fehler aufgetreten',
        ),
      );
    }
  }

  FutureOr<void> _onCourseParticipantsReachedBottom(
    CourseParticipantsReachedBottom event,
    Emitter<CourseParticipantsState> emit,
  ) async {
    if (state
        case CourseParticipantsDidLoad(
          participants: final participants,
          maxReached: false,
          paginationLoading: false,
        )) {
      final currentState = state as CourseParticipantsDidLoad;
      emit(currentState.copyWith(paginationLoading: true));

      try {
        final response = await _courseRepository.getCourseParticipants(
          courseId: courseId,
          offset: participants.length,
          limit: limit,
        );

        final updatedParticipants = [
          ...participants,
          ...response.participants
        ];

        emit(
          CourseParticipantsDidLoad(
            participants: updatedParticipants,
            maxReached:
                updatedParticipants.length >= response.totalParticipants,
            paginationLoading: false,
          ),
        );
      } catch (e) {
        Logger().e(e);
        emit(
          const CourseParticipantsError(
            errorMessage:
                'Beim Laden der Teilnehmer ist ein Fehler aufgetreten',
          ),
        );
      }
    }
  }
}
