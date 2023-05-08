import 'package:bloc/bloc.dart';
import 'package:studipadawan/messages/message_overview/message_tabbar_bloc%20/message_tabbar_event.dart';
import 'package:studipadawan/messages/message_overview/message_tabbar_bloc%20/message_tabbar_state.dart';

class TabBarBloc extends Bloc<TabBarEvent, TabBarState> {
  TabBarBloc() : super(const TabBarState.initial()) {
    on<TabIndexChanged>(_onTabIndexChanged);
    on<ShowMenuIcon>(_onShowMenuIcon);
    on<HideMenuicon>(_onHideMenuIcon);
  }

  void _onTabIndexChanged(
    TabIndexChanged event,
    Emitter<TabBarState> emit,
  ) {
    emit(state.copyWith(
        filterIconVisible: event.index == 0,
        menuIconVisible: false,
        currentTabIndex: event.index,),);
  }

  void _onShowMenuIcon(
    ShowMenuIcon event,
    Emitter<TabBarState> emit,
  ) {
    emit(state.copyWith(
      filterIconVisible: false,
      menuIconVisible: true,
    ),);
  }

  void _onHideMenuIcon(
    HideMenuicon event,
    Emitter<TabBarState> emit,
  ) {
    emit(state.copyWith(
      filterIconVisible: state.currentTabIndex == 0,
      menuIconVisible: false,
    ),);
  }
}
