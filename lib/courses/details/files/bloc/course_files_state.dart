part of 'course_files_bloc.dart';

abstract class CourseFilesState extends Equatable {
  const CourseFilesState();
}

class CourseFilesLoadedState extends CourseFilesState {
  final List<FolderInfo> parentFolders;
  final List<Either<Folder, File>> items;

  const CourseFilesLoadedState(
      {required this.parentFolders, required this.items});

  factory CourseFilesLoadedState.inital() {
    return const CourseFilesLoadedState(parentFolders: [], items: []);
  }

  @override
  List<Object> get props => [parentFolders, items];

  CourseFilesLoadedState copyWith({
    List<FolderInfo>? parentFolders,
    List<Either<Folder, File>>? items,
  }) {
    return CourseFilesLoadedState(
      parentFolders: parentFolders ?? this.parentFolders,
      items: items ?? this.items,
    );
  }
}

class CourseFilesFailureState extends CourseFilesState {
  final String errorMessage;

  const CourseFilesFailureState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class CourseFilesLoadingState extends CourseFilesState {
  @override
  List<Object?> get props => [];
}
