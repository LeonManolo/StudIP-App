import 'package:equatable/equatable.dart';

sealed class TabBarState extends Equatable {
  const TabBarState({
    this.currentTabIndex = 0,
    this.filterIconVisible = true,
    this.messageMenuIconVisible = false,
  });
  final int currentTabIndex;
  final bool filterIconVisible;
  final bool messageMenuIconVisible;

  TabBarState copyWith({
    int? currentTabIndex,
    bool? filterIconVisible,
    bool? messageMenuIconVisible,
  });

  @override
  List<Object?> get props =>
      [currentTabIndex, filterIconVisible, messageMenuIconVisible];
}

class TabBarStateDefault extends TabBarState {
  const TabBarStateDefault({
    super.currentTabIndex,
    super.filterIconVisible,
    super.messageMenuIconVisible,
  });

  factory TabBarStateDefault.fromState(TabBarState state) => TabBarStateDefault(
        currentTabIndex: state.currentTabIndex,
        filterIconVisible: state.filterIconVisible,
        messageMenuIconVisible: state.messageMenuIconVisible,
      );

  @override
  TabBarStateDefault copyWith({
    int? currentTabIndex,
    bool? filterIconVisible,
    bool? messageMenuIconVisible,
  }) {
    return TabBarStateDefault(
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      filterIconVisible: filterIconVisible ?? this.filterIconVisible,
      messageMenuIconVisible:
          messageMenuIconVisible ?? this.messageMenuIconVisible,
    );
  }
}

class TabBarStateMarkAllInboxMessages extends TabBarState {
  const TabBarStateMarkAllInboxMessages({
    super.currentTabIndex,
    super.filterIconVisible,
    super.messageMenuIconVisible,
  });

  factory TabBarStateMarkAllInboxMessages.fromState(TabBarState state) =>
      TabBarStateMarkAllInboxMessages(
        currentTabIndex: state.currentTabIndex,
        filterIconVisible: state.filterIconVisible,
        messageMenuIconVisible: state.messageMenuIconVisible,
      );

  @override
  TabBarStateMarkAllInboxMessages copyWith({
    int? currentTabIndex,
    bool? filterIconVisible,
    bool? messageMenuIconVisible,
  }) {
    return TabBarStateMarkAllInboxMessages(
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      filterIconVisible: filterIconVisible ?? this.filterIconVisible,
      messageMenuIconVisible:
          messageMenuIconVisible ?? this.messageMenuIconVisible,
    );
  }
}

class TabBarStateMarkAllOutboxMessages extends TabBarState {
  const TabBarStateMarkAllOutboxMessages({
    super.currentTabIndex,
    super.filterIconVisible,
    super.messageMenuIconVisible,
  });

  factory TabBarStateMarkAllOutboxMessages.fromState(TabBarState state) =>
      TabBarStateMarkAllOutboxMessages(
        currentTabIndex: state.currentTabIndex,
        filterIconVisible: state.filterIconVisible,
        messageMenuIconVisible: state.messageMenuIconVisible,
      );

  @override
  TabBarStateMarkAllOutboxMessages copyWith({
    int? currentTabIndex,
    bool? filterIconVisible,
    bool? messageMenuIconVisible,
  }) {
    return TabBarStateMarkAllOutboxMessages(
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      filterIconVisible: filterIconVisible ?? this.filterIconVisible,
      messageMenuIconVisible:
          messageMenuIconVisible ?? this.messageMenuIconVisible,
    );
  }
}

class TabBarStateDeleteOutboxMessages extends TabBarState {
  const TabBarStateDeleteOutboxMessages({
    super.currentTabIndex,
    super.filterIconVisible,
    super.messageMenuIconVisible,
  });

  factory TabBarStateDeleteOutboxMessages.fromState(TabBarState state) =>
      TabBarStateDeleteOutboxMessages(
        currentTabIndex: state.currentTabIndex,
        filterIconVisible: state.filterIconVisible,
        messageMenuIconVisible: state.messageMenuIconVisible,
      );

  @override
  TabBarStateDeleteOutboxMessages copyWith({
    int? currentTabIndex,
    bool? filterIconVisible,
    bool? messageMenuIconVisible,
  }) {
    return TabBarStateDeleteOutboxMessages(
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      filterIconVisible: filterIconVisible ?? this.filterIconVisible,
      messageMenuIconVisible:
          messageMenuIconVisible ?? this.messageMenuIconVisible,
    );
  }
}

class TabBarStateDeleteInboxMessages extends TabBarState {
  const TabBarStateDeleteInboxMessages({
    super.currentTabIndex,
    super.filterIconVisible,
    super.messageMenuIconVisible,
  });

  factory TabBarStateDeleteInboxMessages.fromState(TabBarState state) =>
      TabBarStateDeleteInboxMessages(
        currentTabIndex: state.currentTabIndex,
        filterIconVisible: state.filterIconVisible,
        messageMenuIconVisible: state.messageMenuIconVisible,
      );

  @override
  TabBarStateDeleteInboxMessages copyWith({
    int? currentTabIndex,
    bool? filterIconVisible,
    bool? messageMenuIconVisible,
  }) {
    return TabBarStateDeleteInboxMessages(
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      filterIconVisible: filterIconVisible ?? this.filterIconVisible,
    );
  }
}
