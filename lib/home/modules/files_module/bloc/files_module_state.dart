import 'package:equatable/equatable.dart';

sealed class FilesModuleState extends Equatable {
  const FilesModuleState();

  @override
  List<Object?> get props => [];
}

class FilesModuleStateInitial extends FilesModuleState {
  const FilesModuleStateInitial();

  @override
  List<Object?> get props => [];
}

class FilesModuleStateLoading extends FilesModuleState {
  const FilesModuleStateLoading();

  @override
  List<Object?> get props => [];
}

class FilesModuleStateDidLoad extends FilesModuleState {
  const FilesModuleStateDidLoad();

  @override
  List<Object?> get props => [];

  FilesModuleStateDidLoad copyWith() {
    return const FilesModuleStateDidLoad();
  }
}

class FilesModuleStateError extends FilesModuleState {
  const FilesModuleStateError();

  @override
  List<Object?> get props => [];

  FilesModuleStateError copyWith() {
    return const FilesModuleStateError();
  }
}
