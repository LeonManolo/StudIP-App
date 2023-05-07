import 'package:equatable/equatable.dart';


class TabBarState extends Equatable {
  final int currentTabIndex;
  final bool filterIconVisible;
  final bool menuIconVisible;
  const TabBarState({this.currentTabIndex = 0, this.filterIconVisible = true, this.menuIconVisible = false});

  const TabBarState.initial()
      : this(
          filterIconVisible: true,

        );

  @override
  List<Object?> get props => [
       filterIconVisible, menuIconVisible,  currentTabIndex
      ];

  TabBarState copyWith({int? currentTabIndex, bool? filterIconVisible, bool? menuIconVisible}) {
    return TabBarState(
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      filterIconVisible: filterIconVisible ?? this.filterIconVisible,
      menuIconVisible: menuIconVisible ?? this.menuIconVisible,
      );
  }
}
