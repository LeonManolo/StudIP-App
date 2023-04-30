import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart' hide OpenFile;
import 'package:files_repository/files_repository.dart';
import 'package:studipadawan/courses/details/files/models/file_info.dart';
import 'package:studipadawan/courses/details/files/models/folder_info.dart';
import 'package:open_filex/open_filex.dart';

part 'course_files_event.dart';
part 'course_files_state.dart';

class CourseFilesBloc extends Bloc<CourseFilesEvent, CourseFilesState> {
  final FilesRepository _filesRepository;
  final Course course;

  CourseFilesBloc(
      {required this.course, required FilesRepository filesRepository})
      : _filesRepository = filesRepository,
        super(CourseFilesState.inital()) {
    on<LoadRootFolderEvent>(_onLoadRootFolderEvent);
    on<DidSelectFolderEvent>(_onDidSelectFolderEvent);
    on<DidSelectDownloadFileEvent>(_onDidSelectDownloadFileEvent);
    on<DidSelectOpenFileEvent>(_onDidSelectOpenFileEvent);
  }

  FutureOr<void> _onLoadRootFolderEvent(
    LoadRootFolderEvent event,
    Emitter<CourseFilesState> emit,
  ) async {
    emit(state.copyWith(type: CourseFilesStateType.isLoading));
    try {
      final rootFolder =
          await _filesRepository.getCourseRootFolder(courseId: course.id);

      emit(state.copyWith(
          parentFolders: [
            FolderInfo(
                folder: rootFolder,
                folderType: FolderType.root,
                displayName: "Root")
          ],
          items: await _loadItems(parentFolderId: rootFolder.id),
          type: CourseFilesStateType.didLoad));
    } catch (_) {
      emit(state.copyWith(
          errorMessage:
              "Beim Laden der gewünschten Dateien ist ein Problem aufgetreten.",
          type: CourseFilesStateType.error));
    }
  }

  FutureOr<void> _onDidSelectFolderEvent(
      DidSelectFolderEvent event, Emitter<CourseFilesState> emit) async {
    emit(state.copyWith(type: CourseFilesStateType.isLoading));

    try {
      int selectedFolderIndex = event.parentFolders.indexWhere(
          (parentFolder) => parentFolder.folder.id == event.selectedFolder.id);

      List<FolderInfo> newParentFolders = [];
      if (selectedFolderIndex >= 0) {
        newParentFolders =
            event.parentFolders.getRange(0, selectedFolderIndex + 1).toList();
      } else {
        // folder isn't present in parentFolders
        newParentFolders = event.parentFolders
          ..add(FolderInfo.fromFolder(folder: event.selectedFolder));
      }

      emit(state.copyWith(
          parentFolders: newParentFolders)); // immediately update UI

      emit(state.copyWith(
          items: await _loadItems(parentFolderId: event.selectedFolder.id),
          type: CourseFilesStateType.didLoad));
    } catch (_) {
      emit(state.copyWith(
          errorMessage:
              "Beim Laden der gewünschten Dateien ist ein Problem aufgetreten.",
          type: CourseFilesStateType.error));
    }
  }

  FutureOr<void> _onDidSelectDownloadFileEvent(
      DidSelectDownloadFileEvent event, Emitter<CourseFilesState> emit) async {
    final selectedFile = event.selectedFileInfo.file;

    int selectedFileInfoIndex =
        state.items.indexOf(right(event.selectedFileInfo));

    if (selectedFileInfoIndex >= 0 &&
        state.items[selectedFileInfoIndex].isRight()) {
      var updatedItems = List.of(state.items);
      updatedItems[selectedFileInfoIndex] =
          right(FileInfo(fileType: FileType.isDownloading, file: selectedFile));

      emit(state.copyWith(items: updatedItems));
    }

    final localStoragePath =
        await _filesRepository.downloadFile(file: selectedFile);

    if (selectedFileInfoIndex >= 0 &&
        state.items[selectedFileInfoIndex].isRight()) {
      var updatedItems = List.of(state.items);
      updatedItems[selectedFileInfoIndex] = right(FileInfo(
          fileType:
              localStoragePath != null ? FileType.downloaded : FileType.remote,
          file: selectedFile));

      emit(state.copyWith(items: updatedItems));
    }
  }

  FutureOr<void> _onDidSelectOpenFileEvent(
      DidSelectOpenFileEvent event, Emitter<CourseFilesState> emit) async {
    final selectedFile = event.selectedFileInfo.file;

    final localStoragePath =
        await _filesRepository.localFilePath(file: selectedFile);

    OpenFilex.open(localStoragePath, type: selectedFile.mimeType);
  }

  Future<List<Either<Folder, FileInfo>>> _loadItems(
      {required String parentFolderId}) async {
    final result = await Future.wait([
      _filesRepository.getAllVisibleFolders(parentFolderId: parentFolderId),
      _filesRepository.getAllFiles(parentFolderId: parentFolderId)
    ]);

    final folders = result[0]
        .cast()
        .map<Either<Folder, FileInfo>>((folder) => left(folder))
        .toList();

    final files = result[1].cast<File>().toList();
    List<FileInfo> fileInfos = await Future.wait(files.map((file) async {
      FileType fileType =
          (await _filesRepository.isFilePresentAndUpToDate(file: file))
              ? FileType.downloaded
              : FileType.remote;
      return FileInfo(fileType: fileType, file: file);
    }));

    List<Either<Folder, FileInfo>> fileInfosMapped = fileInfos
        .map<Either<Folder, FileInfo>>((fileInfo) => right(fileInfo))
        .toList();

    return folders..addAll(fileInfosMapped);
  }
}
