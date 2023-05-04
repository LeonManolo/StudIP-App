import 'package:equatable/equatable.dart';


abstract class TabBarEvent extends Equatable {
  const TabBarEvent();
}

class TabIndexChanged extends TabBarEvent {
  final int index;

  const TabIndexChanged({required this.index});

  @override
  List<Object?> get props => [index];
}