import 'package:equatable/equatable.dart';

enum FilesModuleStatus {
  initial,
  loading,
  populated,
  failure,
}

class FilesModuleState extends Equatable {
  const FilesModuleState({
    required this.status,
  });

  const FilesModuleState.initial()
      : this(
          status: FilesModuleStatus.initial,
        );
  final FilesModuleStatus status;

  @override
  List<Object?> get props => [status];

  FilesModuleState copyWith({FilesModuleStatus? status}) {
    return FilesModuleState(
      status: status ?? this.status,
    );
  }
}
