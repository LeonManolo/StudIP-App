import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:equatable/equatable.dart';
import '../models/models.dart';

part 'course_info_event.dart';
part 'course_info_state.dart';

class CourseInfoBloc extends Bloc<CourseInfoEvent, CourseInfoState> {
  final List<InfoType> allSections = InfoType.values;
  final CourseRepository _courseRepository;
  final Course course;

  GeneralInfoExpansionModel _generalInfoExpansionModel;
  NewsExpansionModel _newsExpansionModel;
  CourseEventExpansionModel _courseEventExpansionModel;

  CourseInfoBloc(
      {required this.course, required CourseRepository courseRepository})
      : _courseRepository = courseRepository,
        _generalInfoExpansionModel =
            GeneralInfoExpansionModel(courseDetails: course.courseDetails),
        _newsExpansionModel = NewsExpansionModel(news: []),
        _courseEventExpansionModel = CourseEventExpansionModel(events: []),
        super(CourseInfoLoadingState()) {
    on<ToggleSectionEvent>(_onToggleSectionEvent);
    on<TriggerInitialLoadEvent>(_onTriggerInitialLoadEvent);
  }

  FutureOr<void> _onToggleSectionEvent(
      ToggleSectionEvent event, Emitter<CourseInfoState> emit) {
    switch (event.type) {
      case InfoType.general:
        _generalInfoExpansionModel = _generalInfoExpansionModel.copyWith(
            isExpanded: event.newExpansionState);
        break;
      case InfoType.news:
        _newsExpansionModel =
            _newsExpansionModel.copyWith(isExpanded: event.newExpansionState);
        break;
      case InfoType.events:
        _courseEventExpansionModel = _courseEventExpansionModel.copyWith(
            isExpanded: event.newExpansionState);
        break;
    }

    emit(
      CourseInfoPopulatedState(
          generalInfoExpansionModel: _generalInfoExpansionModel,
          newsExpansionModel: _newsExpansionModel,
          eventExpansionModel: _courseEventExpansionModel),
    );
  }

  FutureOr<void> _onTriggerInitialLoadEvent(
      TriggerInitialLoadEvent event, Emitter<CourseInfoState> emit) async {
    final result = await Future.wait([
      _courseRepository.getCourseNews(courseId: course.id, limit: 5),
      _courseRepository.getCourseEvents(courseId: course.id)
    ]);

    _newsExpansionModel = NewsExpansionModel(news: result[0].cast());
    _courseEventExpansionModel =
        CourseEventExpansionModel(events: result[1].cast());

    emit(CourseInfoPopulatedState(
      generalInfoExpansionModel: _generalInfoExpansionModel,
      newsExpansionModel: _newsExpansionModel,
      eventExpansionModel: _courseEventExpansionModel,
    ));
  }
}
