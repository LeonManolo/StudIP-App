part of 'course_files_bloc.dart';

enum CourseFilesStateType { isLoading, didLoad, error }

class CourseFilesState extends Equatable {
  final List<FolderInfo> parentFolders;
  final List<Either<Folder, FileInfo>> items;
  final String? errorMessage;
  final CourseFilesStateType type;

  const CourseFilesState({
    required this.parentFolders,
    required this.items,
    required this.errorMessage,
    required this.type,
  });

  factory CourseFilesState.inital() {
    return const CourseFilesState(
      parentFolders: [],
      items: [],
      errorMessage: null,
      type: CourseFilesStateType.isLoading,
    );
  }

  @override
  List<Object> get props => [parentFolders, items, errorMessage ?? "", type];

  CourseFilesState copyWith({
    List<FolderInfo>? parentFolders,
    List<Either<Folder, FileInfo>>? items,
    String? errorMessage,
    CourseFilesStateType? type,
  }) {
    return CourseFilesState(
      parentFolders: parentFolders ?? this.parentFolders,
      items: items ?? this.items,
      errorMessage: errorMessage ?? this.errorMessage,
      type: type ?? this.type,
    );
  }
}
