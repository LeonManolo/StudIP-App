import 'package:equatable/equatable.dart';
import 'package:files_repository/files_repository.dart';

enum FileType { remote, downloaded, isDownloading }

class FileInfo extends Equatable {
  final FileType fileType;
  final File file;

  const FileInfo({required this.fileType, required this.file});

  @override
  List<Object?> get props => [fileType, file.id];
}
