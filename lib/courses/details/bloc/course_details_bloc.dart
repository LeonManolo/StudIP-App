import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'course_details_event.dart';
part 'course_details_state.dart';

class CourseDetailsBloc
    extends Bloc<CourseDetailsSelectTabEvent, CourseDetailsState> {

  CourseDetailsBloc({required this.course})
      : super(CourseDetailsState.initial(course: course)) {
    on<CourseDetailsSelectTabEvent>(_onTabSelected);
  }
  final allTabs = CourseDetailsTab.values;
  final Course course;

  FutureOr<void> _onTabSelected(
    CourseDetailsSelectTabEvent event,
    Emitter<CourseDetailsState> emit,
  ) {
    emit(CourseDetailsState(selectedTab: event.selectedTab, course: course));
  }
}
