import 'dart:async';
import 'package:bloc/bloc.dart';
import 'message_tabbar_event.dart';
import 'message_tabbar_state.dart';

class TabBarBloc extends Bloc<TabBarEvent, TabBarState> {
  TabBarBloc() : super(const TabBarState.initial()) {
    on<TabIndexChanged>(_onTabIndexChanged);
  }

  Future<void> _onTabIndexChanged(
    TabIndexChanged event,
    Emitter<TabBarState> emit,
  ) async {
    emit(state.copyWith(
        status: event.index == 0
            ? TabBarStatus.filterIconVisible
            : TabBarStatus.filterIconHidden,
            currentTabIndex: event.index));
  }
}
