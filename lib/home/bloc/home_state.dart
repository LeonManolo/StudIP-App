import 'package:equatable/equatable.dart';

enum HomeStatus {
  initial,
  loading,
  populated,
  failure,
}

class HomeState extends Equatable {
  const HomeState({
    required this.status,
  });

  const HomeState.initial()
      : this(
          status: HomeStatus.initial,
        );
  final HomeStatus status;

  @override
  List<Object?> get props => [status];

  HomeState copyWith({HomeStatus? status}) {
    return HomeState(
      status: status ?? this.status,
    );
  }
}
