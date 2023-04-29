import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'package:studipadawan/courses/details/files/models/folder_info.dart';
import 'package:studipadawan/courses/details/files/models/folder_type.dart';

part 'course_files_event.dart';
part 'course_files_state.dart';

class CourseFilesBloc extends Bloc<CourseFilesEvent, CourseFilesState> {
  final CourseRepository _courseRepository;
  final Course course;
  String _courseRootFolderId = "";

  CourseFilesBloc(
      {required this.course, required CourseRepository courseRepository})
      : _courseRepository = courseRepository,
        super(CourseFilesLoadedState.inital()) {
    on<LoadRootFolderEvent>(_onLoadRootFolderEvent);
    on<DidSelectFolderEvent>(_onDidSelectFolderEvent);
  }

  FutureOr<void> _onLoadRootFolderEvent(
    LoadRootFolderEvent event,
    Emitter<CourseFilesState> emit,
  ) async {
    emit(CourseFilesLoadingState());
    try {
      final rootFolder =
          await _courseRepository.getCourseRootFolder(courseId: course.id);
      _courseRootFolderId = rootFolder.id;

      emit(CourseFilesLoadedState(
        parentFolders: [
          FolderInfo(
              folder: rootFolder,
              folderType: FolderType.root,
              displayName: "Root")
        ],
        items: await _loadItems(parentFolderId: rootFolder.id),
      ));
    } catch (_) {
      emit(const CourseFilesFailureState(
          errorMessage:
              "Beim Laden der gewünschten Dateien ist ein Problem aufgetreten."));
    }
  }

  FutureOr<void> _onDidSelectFolderEvent(
      DidSelectFolderEvent event, Emitter<CourseFilesState> emit) async {
    emit(CourseFilesLoadingState());

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
          ..add(FolderInfo(
              displayName: event.selectedFolder.name,
              folderType: _courseRootFolderId == event.selectedFolder.id
                  ? FolderType.root
                  : FolderType.normal,
              folder: event.selectedFolder));
      }

      emit(CourseFilesLoadedState(
          parentFolders: newParentFolders,
          items: await _loadItems(parentFolderId: event.selectedFolder.id)));
    } catch (_) {
      emit(const CourseFilesFailureState(
          errorMessage:
              "Beim Laden der gewünschten Dateien ist ein Problem aufgetreten."));
    }
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
