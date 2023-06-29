part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({required this.selectedModules});
  factory HomeState.inital() => const HomeState(selectedModules: []);

  final List<ModuleType> selectedModules;

  @override
  List<Object> get props => [selectedModules];
}
