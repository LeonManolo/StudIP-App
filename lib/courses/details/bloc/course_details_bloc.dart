import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

part 'course_details_event.dart';
part 'course_details_state.dart';

class CourseDetailsBloc
    extends Bloc<CourseDetailsSelectTabEvent, CourseDetailsState> {
  final allTabs = CourseDetailsTab.values;

  CourseDetailsBloc() : super(const CourseDetailsState.initial()) {
    on<CourseDetailsSelectTabEvent>(_onTabSelected);
  }

  FutureOr<void> _onTabSelected(
    CourseDetailsSelectTabEvent event,
    Emitter<CourseDetailsState> emit,
  ) {
    emit(CourseDetailsState(selectedTab: event.selectedTab));
  }

  bool isSelectedTab(CourseDetailsTab tab) {
    return state.selectedTab == tab;
  }
}
