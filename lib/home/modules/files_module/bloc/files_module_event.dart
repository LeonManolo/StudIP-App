import 'package:equatable/equatable.dart';

abstract class FilesModuleEvent extends Equatable {
  const FilesModuleEvent();
}

class FileActivitiesRequested extends FilesModuleEvent {
  const FileActivitiesRequested();

  @override
  List<Object?> get props => [];
}
