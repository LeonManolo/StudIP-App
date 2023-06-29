part of 'module_bloc.dart';

abstract class ModuleEvent extends Equatable {
  const ModuleEvent();

  @override
  List<Object> get props => [];
}

class ModuleItemsRequested extends ModuleEvent {
  const ModuleItemsRequested();
}
