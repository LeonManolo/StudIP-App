import 'package:equatable/equatable.dart';

abstract class TabBarEvent extends Equatable {
  const TabBarEvent();
}

class TabIndexChanged extends TabBarEvent {
  const TabIndexChanged({required this.index});
  final int index;
  @override
  List<Object?> get props => [index];
}

class ShowMenuIcon extends TabBarEvent {
  const ShowMenuIcon();
  @override
  List<Object?> get props => [];
}

class HideMenuicon extends TabBarEvent {
  const HideMenuicon();
  @override
  List<Object?> get props => [];
}
