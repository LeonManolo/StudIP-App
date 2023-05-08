part of 'course_files_bloc.dart';

abstract class CourseFilesEvent extends Equatable {
  const CourseFilesEvent();
}

class LoadRootFolderEvent extends CourseFilesEvent {
  @override
  List<Object?> get props => [];
}

class DidSelectFolderEvent extends CourseFilesEvent {

  const DidSelectFolderEvent(
      {required this.selectedFolder, required this.parentFolders,});
  final Folder selectedFolder;
  final List<FolderInfo> parentFolders;

  @override
  List<Object> get props => [selectedFolder, parentFolders];
}

class DidSelectFileEvent extends CourseFilesEvent {

  const DidSelectFileEvent({required this.selectedFileInfo});
  final FileInfo selectedFileInfo;

  @override
  List<Object?> get props => [selectedFileInfo];
}
