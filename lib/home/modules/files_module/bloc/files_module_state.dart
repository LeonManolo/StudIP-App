import 'package:activity_repository/activity_repository.dart';
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
  const FilesModuleStateDidLoad({
    this.fileActivities = const [],
  });
  final List<FileActivity> fileActivities;

  @override
  List<Object?> get props => [fileActivities];
}

class FilesModuleStateError extends FilesModuleState {
  const FilesModuleStateError();

  @override
  List<Object?> get props => [];
}
