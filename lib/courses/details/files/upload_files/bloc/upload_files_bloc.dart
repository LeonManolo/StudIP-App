import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart' as file_picker hide FileType;
import 'package:files_repository/files_repository.dart';
import 'package:open_filex/open_filex.dart';
import 'package:studipadawan/courses/details/files/upload_files/model/upload_file_model.dart';

part 'upload_files_event.dart';
part 'upload_files_state.dart';

class UploadFilesBloc extends Bloc<UploadFilesEvent, UploadFilesState> {
  UploadFilesBloc({
    required this.parentFolderId,
    required FilesRepository filesRepository,
    required this.onSuccessCallback,
  })  : _filesRepository = filesRepository,
        super(UploadFilesState.initial()) {
    on<DidSelectAddFilesEvent>(_handleDidSelectAddFilesEvent);
    on<DidSelectUploadFilesEvent>(_handleDidSelectUploadFilesEvent);
    on<DidSelectPickedFileEvent>(_handleDidSelectPickedFileEvent);
    on<DeletePickedFileEvent>(_handleDeletePickedFileEvent);
  }

  final String parentFolderId;
  final FilesRepository _filesRepository;
  final void Function() onSuccessCallback;

  FutureOr<void> _handleDidSelectAddFilesEvent(
    DidSelectAddFilesEvent event,
    Emitter<UploadFilesState> emit,
  ) async {
    final file_picker.FilePickerResult? result = await file_picker
        .FilePicker.platform
        .pickFiles(lockParentWindow: true, allowMultiple: true);

    if (result == null) return;

    final List<UploadFileModel> uploadFileModelsToAppend = result.files
        .map((platformFile) {
          if (platformFile.path == null) return null;
          return UploadFileModel(
            localFilePath: platformFile.path!,
            fileName: platformFile.name,
          );
        })
        .whereNotNull()
        .toList();

    final newUploadFileModels = state.filesToUpload + uploadFileModelsToAppend;

    emit(
      UploadFilesState(
        type: newUploadFileModels.isEmpty
            ? UploadFileStateType.empty
            : UploadFileStateType.populated,
        filesToUpload: newUploadFileModels,
      ),
    );
  }

  FutureOr<void> _handleDidSelectUploadFilesEvent(
    DidSelectUploadFilesEvent event,
    Emitter<UploadFilesState> emit,
  ) async {
    emit(state.copyWith(type: UploadFileStateType.loading));

    try {
      await _filesRepository.uploadFiles(
        parentFolderId: parentFolderId,
        localFilePaths: event.localFilePaths,
      );
      onSuccessCallback();
      emit(state.copyWith(type: UploadFileStateType.success));
    } on UploadFilesFailure catch (uploadFilesFailure) {
      emit(
        state.copyWith(
          type: UploadFileStateType.failure,
          failureMessage: uploadFilesFailure.message,
        ),
      );
    }
  }

  FutureOr<void> _handleDidSelectPickedFileEvent(
    DidSelectPickedFileEvent event,
    Emitter<UploadFilesState> emit,
  ) async {
    await OpenFilex.open(event.localFilePath);
  }

  FutureOr<void> _handleDeletePickedFileEvent(
    DeletePickedFileEvent event,
    Emitter<UploadFilesState> emit,
  ) async {
    final List<UploadFileModel> newUploadFileModels =
        List.of(state.filesToUpload)..removeAt(event.selectedIndex);

    emit(
      UploadFilesState(
        type: newUploadFileModels.isEmpty
            ? UploadFileStateType.empty
            : UploadFileStateType.populated,
        filesToUpload: newUploadFileModels,
      ),
    );
  }
}
