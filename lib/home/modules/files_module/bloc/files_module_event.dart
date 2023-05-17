import 'package:equatable/equatable.dart';

abstract class FilesModuleEvent extends Equatable {
  const FilesModuleEvent();
}

class CoursesRequested extends FilesModuleEvent {
  @override
  List<Object?> get props => [];
}
