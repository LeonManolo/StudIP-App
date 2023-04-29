part of 'course_files_bloc.dart';

abstract class CourseFilesEvent extends Equatable {
  const CourseFilesEvent();

  @override
  List<Object> get props => [];
}

class LoadRootFolderEvent extends CourseFilesEvent {}

class DidSelectFolderEvent extends CourseFilesEvent {
  final Folder selectedFolder;
  final List<FolderInfo> parentFolders;

  const DidSelectFolderEvent(
      {required this.selectedFolder, required this.parentFolders});

  @override
  List<Object> get props => [selectedFolder, parentFolders];
}
