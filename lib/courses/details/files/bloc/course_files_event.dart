part of 'course_files_bloc.dart';

abstract class CourseFilesEvent extends Equatable {
  const CourseFilesEvent();
}

class LoadRootFolderEvent extends CourseFilesEvent {
  @override
  List<Object?> get props => [];
}

class DidSelectFolderEvent extends CourseFilesEvent {
  final Folder selectedFolder;
  final List<FolderInfo> parentFolders;

  const DidSelectFolderEvent(
      {required this.selectedFolder, required this.parentFolders});

  @override
  List<Object> get props => [selectedFolder, parentFolders];
}

class DidSelectFileEvent extends CourseFilesEvent {
  final File selectedFile;

  const DidSelectFileEvent({required this.selectedFile});

  @override
  List<Object?> get props => [selectedFile];
}
