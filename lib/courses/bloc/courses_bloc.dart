import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:collection/collection.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:studipadawan/courses/bloc/courses_event.dart';
import 'package:studipadawan/courses/bloc/courses_state.dart';

class CoursesBloc extends HydratedBloc<CourseEvent, CoursesState> {
  CoursesBloc({
    required CourseRepository courseRepository,
    required AuthenticationRepository authenticationRepository,
    required DateTime todayDateTime,
    SemesterSortOrder? initialSortOrder,
    SemesterFilter? initialFilter,
  })  : _courseRepository = courseRepository,
        _authenticationRepository = authenticationRepository,
        _todayDateTime = todayDateTime,
        super(
          CoursesStateLoading(
            semesterFilter: initialFilter ?? CoursesState.defaultSemesterFilter,
            semesterSortOrder:
                initialSortOrder ?? CoursesState.defaultSemesterSortOrder,
          ),
        ) {
    on<CoursesRequested>(_onCourseRequested);
    on<SemesterFilterChanged>(_onSemesterFilterChanged);
    on<SemesterSortOrderChanged>(_onSemesterSortOrderChanged);
  }
  final CourseRepository _courseRepository;
  final AuthenticationRepository _authenticationRepository;
  final DateTime _todayDateTime;
  List<Semester> _allSemesters = [];

  @override
  CoursesState? fromJson(Map<String, dynamic> json) {
    final rawSavedFilter = json['semesterFilter'];
    final rawSavedSortOrder = json['semesterSortOrder'];
    if (rawSavedFilter is! String || rawSavedSortOrder is! String) {
      return null;
    }

    final SemesterFilter savedFilter =
        SemesterFilter.values.byName(rawSavedFilter);
    final SemesterSortOrder savedSortOrder =
        SemesterSortOrder.values.byName(rawSavedSortOrder);

    return CoursesStateLoading(
      semesterFilter: savedFilter,
      semesterSortOrder: savedSortOrder,
    );
  }

  @override
  Map<String, dynamic>? toJson(CoursesState state) {
    return {
      'semesterFilter': state.semesterFilter.name,
      'semesterSortOrder': state.semesterSortOrder.name
    };
  }

  FutureOr<void> _onCourseRequested(
    CoursesRequested event,
    Emitter<CoursesState> emit,
  ) async {
    emit(
      CoursesStateLoading(
        semesterFilter: state.semesterFilter,
        semesterSortOrder: state.semesterSortOrder,
      ),
    );

    try {
      final semesters = await _courseRepository.getCoursesGroupedBySemester(
        _authenticationRepository.currentUser.id,
      );
      _allSemesters = semesters;
      emit(
        CoursesStateDidLoad(
          semesters: _updateSemesters(
            semesters: semesters,
            sortOrder: state.semesterSortOrder,
            filter: state.semesterFilter,
          ),
          semesterFilter: state.semesterFilter,
          semesterSortOrder: state.semesterSortOrder,
        ),
      );
    } catch (_) {
      emit(
        CoursesStateError(
          errorMessage:
              'Es ist ein Fehler aufgetreten. Versuche es später erneut.',
          semesterFilter: state.semesterFilter,
          semesterSortOrder: state.semesterSortOrder,
        ),
      );
    }
  }

  FutureOr<void> _onSemesterFilterChanged(
    SemesterFilterChanged event,
    Emitter<CoursesState> emit,
  ) {
    switch (state) {
      case CoursesStateLoading _:
      case CoursesStateError _:
        break;
      case final CoursesStateDidLoad currentStateDidLoad:
        emit(
          currentStateDidLoad.copyWith(
            semesters: _updateSemesters(
              semesters: _allSemesters,
              sortOrder: state.semesterSortOrder,
              filter: event.selectedSemesterFilter,
            ),
            semesterFilter: event.selectedSemesterFilter,
          ),
        );
    }
  }

  FutureOr<void> _onSemesterSortOrderChanged(
    SemesterSortOrderChanged event,
    Emitter<CoursesState> emit,
  ) {
    switch (state) {
      case CoursesStateLoading _:
      case CoursesStateError _:
        break;
      case final CoursesStateDidLoad currentStateDidLoad:
        emit(
          currentStateDidLoad.copyWith(
            semesters: _sortSemesters(
              semesters: currentStateDidLoad.semesters,
              sortOrder: event.selectedSemesterSortOrder,
            ),
            semesterSortOrder: event.selectedSemesterSortOrder,
          ),
        );
    }
  }

  List<Semester> _updateSemesters({
    required List<Semester> semesters,
    required SemesterSortOrder sortOrder,
    required SemesterFilter filter,
  }) {
    final filteredSemesters =
        _filterSemesters(semesters: semesters, filter: filter);
    return _sortSemesters(semesters: filteredSemesters, sortOrder: sortOrder);
  }

  List<Semester> _sortSemesters({
    required List<Semester> semesters,
    required SemesterSortOrder sortOrder,
  }) {
    return semesters.sorted((semester1, semester2) {
      switch (sortOrder) {
        case SemesterSortOrder.asc:
          return semester1.start.compareTo(semester2.start);

        case SemesterSortOrder.desc:
          return semester2.start.compareTo(semester1.start);
      }
    });
  }

  List<Semester> _filterSemesters({
    required List<Semester> semesters,
    required SemesterFilter filter,
  }) {
    return semesters.where((semester) {
      switch (filter) {
        case SemesterFilter.all:
          return true;
        case SemesterFilter.current:
          return semester.isCurrentSemester(
            currentDateTime: _todayDateTime.toLocal(),
          );
      }
    }).toList();
  }
}
