import 'package:equatable/equatable.dart';
import 'package:messages_repository/messages_repository.dart';

enum TabBarStatus { filterIconVisible, filterIconHidden }

class TabBarState extends Equatable {
  final TabBarStatus status;
  final int currentTabIndex;
  const TabBarState({required this.status, this.currentTabIndex = 0});

  const TabBarState.initial()
      : this(
          status: TabBarStatus.filterIconVisible,
        );

  @override
  List<Object?> get props => [
        status, currentTabIndex
      ];

  TabBarState copyWith({TabBarStatus? status, List<Message>? inboxMessages, int? currentTabIndex}) {
    return TabBarState(
      status: status ?? this.status,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      );
  }
}
