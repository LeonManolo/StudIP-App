part of 'module_bloc.dart';

sealed class ModuleState extends Equatable {
  const ModuleState();
}

final class ModuleLoaded extends ModuleState {
  const ModuleLoaded({required this.previewModels});
  factory ModuleLoaded.initial() => const ModuleLoaded(previewModels: []);

  final List<PreviewModel> previewModels;

  @override
  List<Object> get props => [previewModels];
}

class ModuleError extends ModuleState {
  const ModuleError({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
