part of 'upload_files_bloc.dart';

abstract class UploadFilesEvent extends Equatable {
  const UploadFilesEvent();

  @override
  List<Object> get props => [];
}

class DidSelectAddFilesEvent extends UploadFilesEvent {}

class DidSelectUploadFilesEvent extends UploadFilesEvent {
  const DidSelectUploadFilesEvent({required this.localFilePaths});

  final List<String> localFilePaths;
  @override
  List<Object> get props => [localFilePaths];
}

class DidSelectPickedFileEvent extends UploadFilesEvent {
  const DidSelectPickedFileEvent({required this.localFilePath});

  final String localFilePath;

  @override
  List<Object> get props => [localFilePath];
}

class DeletePickedFileEvent extends UploadFilesEvent {
  const DeletePickedFileEvent({required this.selectedIndex});

  final int selectedIndex;
}
