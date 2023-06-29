import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:dartz/dartz.dart' hide OpenFile;
import 'package:equatable/equatable.dart';
import 'package:files_repository/files_repository.dart';
import 'package:logger/logger.dart';
import 'package:open_filex/open_filex.dart';
import 'package:studipadawan/courses/details/files/models/file_info.dart';
import 'package:studipadawan/courses/details/files/models/folder_info.dart';

part 'course_files_event.dart';
part 'course_files_state.dart';

class CourseFilesBloc extends Bloc<CourseFilesEvent, CourseFilesState> {
  CourseFilesBloc({
    required this.course,
    required FilesRepository filesRepository,
  })  : _filesRepository = filesRepository,
        super(CourseFilesState.inital()) {
    on<LoadRootFolderEvent>(_onLoadRootFolderEvent);
    on<DidSelectFolderEvent>(_onDidSelectFolderEvent);
    on<DidSelectFileEvent>(_onDidSelectFileEvent);
    on<DidFinishNewFolderCreationEvent>(_onDidFinishNewFolderCreationEvent);
    on<DidFinishFileUploadEvent>(_onDidFinishFileUploadEvent);
  }
  final FilesRepository _filesRepository;
  final Course course;

  FutureOr<void> _onLoadRootFolderEvent(
    LoadRootFolderEvent event,
    Emitter<CourseFilesState> emit,
  ) async {
    emit(state.copyWith(type: CourseFilesStateType.isLoading));
    try {
      final rootFolder =
          await _filesRepository.getCourseRootFolder(courseId: course.id);
      final parentFolderInfo = FolderInfo(
        folder: rootFolder,
        folderType: FolderType.root,
        displayName: 'Start',
      );

      emit(
        state.copyWith(
          parentFolders: [parentFolderInfo],
          items: await _loadItems(parentFolders: [parentFolderInfo]),
          type: CourseFilesStateType.didLoad,
        ),
      );
    } catch (e) {
      Logger().e(e);
      emit(
        state.copyWith(
          errorMessage:
              'Beim Laden der gewünschten Dateien ist ein Problem aufgetreten.',
          type: CourseFilesStateType.error,
        ),
      );
    }
  }

  FutureOr<void> _onDidSelectFolderEvent(
    DidSelectFolderEvent event,
    Emitter<CourseFilesState> emit,
  ) async {
    emit(state.copyWith(type: CourseFilesStateType.isLoading));

    try {
      final int selectedFolderIndex = event.parentFolders.indexWhere(
        (parentFolder) => parentFolder.folder.id == event.selectedFolder.id,
      );

      List<FolderInfo> newParentFolders = [];
      if (selectedFolderIndex >= 0) {
        newParentFolders =
            event.parentFolders.getRange(0, selectedFolderIndex + 1).toList();
      } else {
        // folder isn't present in parentFolders
        newParentFolders = event.parentFolders +
            [FolderInfo.fromFolder(folder: event.selectedFolder)];
      }

      emit(
        state.copyWith(
          parentFolders: newParentFolders,
        ),
      ); // immediately update UI

      emit(
        state.copyWith(
          items: await _loadItems(parentFolders: newParentFolders),
          type: CourseFilesStateType.didLoad,
        ),
      );
    } catch (e) {
      Logger().e(e);
      emit(
        state.copyWith(
          errorMessage:
              'Beim Laden der gewünschten Dateien ist ein Problem aufgetreten.',
          type: CourseFilesStateType.error,
        ),
      );
    }
  }

  FutureOr<void> _onDidSelectFileEvent(
    DidSelectFileEvent event,
    Emitter<CourseFilesState> emit,
  ) async {
    final selectedFileInfo = event.selectedFileInfo;

    if (selectedFileInfo.fileType == FileType.remote) {
      final String? localStoragePath =
          await _downloadFile(selectedFileInfo, emit);

      if (localStoragePath != null) {
        await OpenFilex.open(
          localStoragePath,
          type: selectedFileInfo.file.mimeType,
        );
      }
    } else if (selectedFileInfo.fileType == FileType.downloaded) {
      final localStoragePath = await _filesRepository.localFilePath(
        file: selectedFileInfo.file,
        parentFolderIds: state.parentFolderIds,
      );

      await OpenFilex.open(
        localStoragePath,
        type: selectedFileInfo.file.mimeType,
      );
    }
  }

  FutureOr<void> _onDidFinishNewFolderCreationEvent(
    DidFinishNewFolderCreationEvent event,
    Emitter<CourseFilesState> emit,
  ) async {
    emit(state.copyWith(type: CourseFilesStateType.isLoading));

    try {
      await _filesRepository.createNewFolder(
        courseId: course.id,
        parentFolderId: state.parentFolderIds.last,
        folderName: event.folderName,
      );

      await _reloadCurrentFolder(emit);
    } catch (e) {
      Logger().e(e);
      emit(
        state.copyWith(
          type: CourseFilesStateType.error,
          errorMessage:
              'Bei der Erstellung des Ordners ist ein Problem aufgetreten',
        ),
      );
    }
  }

  FutureOr<void> _onDidFinishFileUploadEvent(
    DidFinishFileUploadEvent event,
    Emitter<CourseFilesState> emit,
  ) async {
    await _reloadCurrentFolder(emit);
  }

  FutureOr<void> _reloadCurrentFolder(Emitter<CourseFilesState> emit) async {
    try {
      emit(
        state.copyWith(
          items: await _loadItems(parentFolders: state.parentFolders),
          type: CourseFilesStateType.didLoad,
        ),
      );
    } catch (e) {
      Logger().e(e);
      emit(
        state.copyWith(
          errorMessage:
              'Beim Laden der gewünschten Dateien ist ein Problem aufgetreten.',
          type: CourseFilesStateType.error,
        ),
      );
    }
  }

  /// If download was successful, returns the local storage path of the downloaded file
  Future<String?> _downloadFile(
    FileInfo fileInfo,
    Emitter<CourseFilesState> emit,
  ) async {
    final File fileToDownload = fileInfo.file;

    final int selectedFileInfoIndex = state.items.indexOf(right(fileInfo));

    if (selectedFileInfoIndex >= 0 &&
        state.items[selectedFileInfoIndex].isRight()) {
      final updatedItems = List.of(state.items);
      updatedItems[selectedFileInfoIndex] = right(
        FileInfo(fileType: FileType.isDownloading, file: fileToDownload),
      );

      emit(state.copyWith(items: updatedItems));
    }

    final localStoragePath = await _filesRepository.downloadFile(
      file: fileToDownload,
      parentFolderIds: state.parentFolderIds,
    );

    if (selectedFileInfoIndex >= 0 &&
        state.items[selectedFileInfoIndex].isRight()) {
      final updatedItems = List.of(state.items);
      updatedItems[selectedFileInfoIndex] = right(
        FileInfo(
          fileType:
              localStoragePath != null ? FileType.downloaded : FileType.remote,
          file: fileToDownload,
        ),
      );

      emit(state.copyWith(items: updatedItems));
    }

    return localStoragePath;
  }

  /// Used to load all items for the last folder in [parentFolders]
  Future<List<Either<Folder, FileInfo>>> _loadItems({
    required List<FolderInfo> parentFolders,
  }) async {
    final String directParentFolderId = parentFolders.last.folder.id;
    final List<String> parentFolderIds =
        parentFolders.map((folderInfo) => folderInfo.folder.id).toList();

    final result = await Future.wait([
      _filesRepository.getAllVisibleFolders(
        parentFolderId: directParentFolderId,
      ),
      _filesRepository.getAllDownloadableFiles(
        parentFolderId: directParentFolderId,
      )
    ]);

    final List<Either<Folder, FileInfo>> folders =
        result[0].cast<Folder>().map<Either<Folder, FileInfo>>(left).toList();

    final files = result[1].cast<File>().toList();
    final List<FileInfo> fileInfos = await Future.wait(
      files.map((file) async {
        final FileType fileType =
            (await _filesRepository.isFilePresentAndUpToDate(
          file: file,
          parentFolderIds: parentFolderIds,
        ))
                ? FileType.downloaded
                : FileType.remote;
        return FileInfo(fileType: fileType, file: file);
      }),
    );

    final List<Either<Folder, FileInfo>> fileInfosMapped =
        fileInfos.map<Either<Folder, FileInfo>>(right).toList();

    final List<Either<Folder, FileInfo>> newItems = folders
      ..addAll(fileInfosMapped);
    final List<String> itemIds = newItems.map<String>(
      (item) {
        return item.fold((folder) => folder.id, (fileInfo) => fileInfo.file.id);
      },
    ).toList();

    // Delete obsolete ressources from disk
    await _filesRepository.cleanup(
      parentFolderIds: parentFolderIds,
      expectedIds: itemIds,
    );

    return newItems;
  }
}
