import 'package:equatable/equatable.dart';

enum NewsModuleStatus {
  initial,
  loading,
  populated,
  failure,
}

class NewsModuleState extends Equatable {
  const NewsModuleState({
    required this.status,
  });

  const NewsModuleState.initial()
      : this(
          status: NewsModuleStatus.initial,
        );
  final NewsModuleStatus status;

  @override
  List<Object?> get props => [status];

  NewsModuleState copyWith({NewsModuleStatus? status}) {
    return NewsModuleState(
      status: status ?? this.status,
    );
  }
}
