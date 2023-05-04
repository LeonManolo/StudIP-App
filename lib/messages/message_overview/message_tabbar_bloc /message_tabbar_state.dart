import 'package:equatable/equatable.dart';
import 'package:messages_repository/messages_repository.dart';

enum TabBarStatus { filterIconVisible, filterIconHidden }

class TabBarState extends Equatable {
  final TabBarStatus status;

  const TabBarState({required this.status});

  const TabBarState.initial()
      : this(
          status: TabBarStatus.filterIconVisible,
        );

  @override
  List<Object?> get props => [
        status,
      ];

  TabBarState copyWith({TabBarStatus? status, List<Message>? inboxMessages}) {
    return TabBarState(status: status ?? this.status);
  }
}
