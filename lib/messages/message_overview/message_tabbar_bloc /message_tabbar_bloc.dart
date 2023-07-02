import 'package:bloc/bloc.dart';
import 'package:studipadawan/messages/message_overview/message_tabbar_bloc%20/message_tabbar_event.dart';
import 'package:studipadawan/messages/message_overview/message_tabbar_bloc%20/message_tabbar_state.dart';

class TabBarBloc extends Bloc<TabBarEvent, TabBarState> {
  TabBarBloc() : super(const TabBarStateDefault()) {
    on<TabIndexChanged>(_onTabIndexChanged);
    on<ShowMenuIcon>(_onShowMenuIcon);
    on<HideMenuicon>(_onHideMenuIcon);
    on<MarkAllMessages>(_onMarkAllMessages);
    on<DeleteMarkedMessages>(_onDeleteMarkedMessages);
  }

  void _onTabIndexChanged(
    TabIndexChanged event,
    Emitter<TabBarState> emit,
  ) {
    emit(
      TabBarStateDefault.fromState(
        state.copyWith(
          filterIconVisible: event.index == 0,
          messageMenuIconVisible: false,
          currentTabIndex: event.index,
        ),
      ),
    );
  }

  void _onShowMenuIcon(
    ShowMenuIcon event,
    Emitter<TabBarState> emit,
  ) {
    emit(
      TabBarStateDefault.fromState(
        state.copyWith(
          filterIconVisible: false,
          messageMenuIconVisible: true,
        ),
      ),
    );
  }

  void _onHideMenuIcon(
    HideMenuicon event,
    Emitter<TabBarState> emit,
  ) {
    emit(
      TabBarStateDefault.fromState(
        state.copyWith(
          filterIconVisible: state.currentTabIndex == 0,
          messageMenuIconVisible: false,
        ),
      ),
    );
  }

  void _onMarkAllMessages(
    MarkAllMessages event,
    Emitter<TabBarState> emit,
  ) {
    if (state.currentTabIndex == 0) {
      emit(TabBarStateMarkAllInboxMessages.fromState(state));
    } else {
      emit(TabBarStateMarkAllOutboxMessages.fromState(state));
    }
    emit(TabBarStateDefault.fromState(state));
  }

  void _onDeleteMarkedMessages(
    DeleteMarkedMessages event,
    Emitter<TabBarState> emit,
  ) {
    if (state.currentTabIndex == 0) {
      emit(TabBarStateDeleteInboxMessages.fromState(state));
    } else {
      emit(TabBarStateDeleteOutboxMessages.fromState(state));
    }
    emit(TabBarStateDefault.fromState(state));
  }
}
