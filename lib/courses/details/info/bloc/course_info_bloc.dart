import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:studipadawan/courses/details/info/models/models.dart';

part 'course_info_event.dart';
part 'course_info_state.dart';

class CourseInfoBloc extends Bloc<CourseInfoEvent, CourseInfoState> {
  CourseInfoBloc({
    required this.course,
    required CourseRepository courseRepository,
  })  : _courseRepository = courseRepository,
        _generalInfoExpansionModel =
            GeneralInfoExpansionModel(courseDetails: course.courseDetails),
        _courseEventExpansionModel = CourseEventExpansionModel(events: []),
        super(CourseInfoLoadingState()) {
    on<ToggleSectionEvent>(_onToggleSectionEvent);
    on<TriggerInitialLoadEvent>(_onTriggerInitialLoadEvent);
  }
  final List<InfoType> allSections = InfoType.values;
  final CourseRepository _courseRepository;
  final Course course;

  GeneralInfoExpansionModel _generalInfoExpansionModel;
  CourseEventExpansionModel _courseEventExpansionModel;

  FutureOr<void> _onToggleSectionEvent(
    ToggleSectionEvent event,
    Emitter<CourseInfoState> emit,
  ) {
    switch (event.type) {
      case InfoType.general:
        _generalInfoExpansionModel = _generalInfoExpansionModel.copyWith(
          isExpanded: event.newExpansionState,
        );
        break;
      case InfoType.events:
        _courseEventExpansionModel = _courseEventExpansionModel.copyWith(
          isExpanded: event.newExpansionState,
        );
        break;
    }

    emit(
      CourseInfoPopulatedState(
        generalInfoExpansionModel: _generalInfoExpansionModel,
        eventExpansionModel: _courseEventExpansionModel,
      ),
    );
  }

  FutureOr<void> _onTriggerInitialLoadEvent(
    TriggerInitialLoadEvent event,
    Emitter<CourseInfoState> emit,
  ) async {
    final List<StudIPCourseEvent> newEvents =
        await _courseRepository.getCourseEvents(courseId: course.id);
    _courseEventExpansionModel = CourseEventExpansionModel(events: newEvents);

    emit(
      CourseInfoPopulatedState(
        generalInfoExpansionModel: _generalInfoExpansionModel,
        eventExpansionModel: _courseEventExpansionModel,
      ),
    );
  }
}
