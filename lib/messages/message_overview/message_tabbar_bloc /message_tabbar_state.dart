import 'package:equatable/equatable.dart';

class TabBarState extends Equatable {
  const TabBarState({
    this.currentTabIndex = 0,
    this.filterIconVisible = true,
    this.messageDeleteButtonVisible = false,
  });

  const TabBarState.initial() : this(filterIconVisible: true);
  final int currentTabIndex;
  final bool filterIconVisible;
  final bool messageDeleteButtonVisible;

  @override
  List<Object?> get props =>
      [filterIconVisible, messageDeleteButtonVisible, currentTabIndex];

  TabBarState copyWith({
    int? currentTabIndex,
    bool? filterIconVisible,
    bool? menuIconVisible,
  }) {
    return TabBarState(
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      filterIconVisible: filterIconVisible ?? this.filterIconVisible,
      messageDeleteButtonVisible:
          menuIconVisible ?? this.messageDeleteButtonVisible,
    );
  }
}
