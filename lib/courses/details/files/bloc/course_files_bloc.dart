import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart' hide OpenFile;
import 'package:studipadawan/courses/bloc/courses_state.dart';
import 'package:studipadawan/courses/details/files/models/folder_info.dart';
import 'package:studipadawan/courses/details/files/models/folder_type.dart';
import 'package:open_filex/open_filex.dart';

part 'course_files_event.dart';
part 'course_files_state.dart';

class CourseFilesBloc extends Bloc<CourseFilesEvent, CourseFilesState> {
  final CourseRepository _courseRepository;
  final Course course;
  String _courseRootFolderId = "";

  CourseFilesBloc(
      {required this.course, required CourseRepository courseRepository})
      : _courseRepository = courseRepository,
        super(CourseFilesState.inital()) {
    on<LoadRootFolderEvent>(_onLoadRootFolderEvent);
    on<DidSelectFolderEvent>(_onDidSelectFolderEvent);
    on<DidSelectFileEvent>(_onDidSelectFileEvent);
  }

  FutureOr<void> _onLoadRootFolderEvent(
    LoadRootFolderEvent event,
    Emitter<CourseFilesState> emit,
  ) async {
    emit(state.copyWith(type: CourseFilesStateType.isLoading));
    try {
      final rootFolder =
          await _courseRepository.getCourseRootFolder(courseId: course.id);
      _courseRootFolderId = rootFolder.id;

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

  FutureOr<void> _onDidSelectFileEvent(
      DidSelectFileEvent event, Emitter<CourseFilesState> emit) async {
    final localStoragePath = await _courseRepository.downloadFile(
        fileId: event.selectedFile.id,
        localFilePath: "${event.selectedFile.id}/${event.selectedFile.name}");

    OpenFilex.open(localStoragePath, type: event.selectedFile.mimeType);
  }

  Future<List<Either<Folder, File>>> _loadItems(
      {required String parentFolderId}) async {
    final result = await Future.wait([
      _courseRepository.getAllFolders(parentFolderId: parentFolderId),
      _courseRepository.getAllFiles(parentFolderId: parentFolderId)
    ]);

    final folders = result[0]
        .cast()
        .map<Either<Folder, File>>((folder) => left(folder))
        .toList();
    final files = result[1]
        .cast()
        .map<Either<Folder, File>>((file) => right(file))
        .toList();

    return folders..addAll(files);
  }
}
