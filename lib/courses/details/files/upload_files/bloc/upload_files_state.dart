part of 'upload_files_bloc.dart';

enum UploadFileStateType { populated, empty, loading, failure, success }

class UploadFilesState extends Equatable {
  const UploadFilesState({
    required this.filesToUpload,
    required this.type,
    this.failureMessage,
  });

  UploadFilesState.initial()
      : this(filesToUpload: [], type: UploadFileStateType.empty);

  final List<UploadFileModel> filesToUpload;
  final UploadFileStateType type;
  final String? failureMessage;

  @override
  List<Object> get props => [filesToUpload, type, failureMessage ?? ''];

  UploadFilesState copyWith({
    List<UploadFileModel>? filesToUpload,
    UploadFileStateType? type,
    String? failureMessage,
  }) {
    return UploadFilesState(
      filesToUpload: filesToUpload ?? this.filesToUpload,
      type: type ?? this.type,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }
}
