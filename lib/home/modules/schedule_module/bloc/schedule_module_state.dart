import 'package:equatable/equatable.dart';

enum ScheduleModuleStatus {
  initial,
  loading,
  populated,
  failure,
}

class ScheduleModuleState extends Equatable {
  const ScheduleModuleState({
    required this.status,
  });

  const ScheduleModuleState.initial()
      : this(
          status: ScheduleModuleStatus.initial,
        );
  final ScheduleModuleStatus status;

  @override
  List<Object?> get props => [status];

  ScheduleModuleState copyWith({ScheduleModuleStatus? status}) {
    return ScheduleModuleState(
      status: status ?? this.status,
    );
  }
}
