import 'package:equatable/equatable.dart';

sealed class CalendarModuleState extends Equatable {
  const CalendarModuleState();

  @override
  List<Object?> get props => [];
}

class CalendarModuleStateInitial extends CalendarModuleState {
  const CalendarModuleStateInitial();

  @override
  List<Object?> get props => [];
}

class CalendarModuleStateLoading extends CalendarModuleState {
  const CalendarModuleStateLoading();

  @override
  List<Object?> get props => [];
}

class CalendarModuleStateDidLoad extends CalendarModuleState {
  const CalendarModuleStateDidLoad();

  @override
  List<Object?> get props => [];

  CalendarModuleStateDidLoad copyWith() {
    return const CalendarModuleStateDidLoad();
  }
}

class CalendarModuleStateError extends CalendarModuleState {
  const CalendarModuleStateError();

  @override
  List<Object?> get props => [];

  CalendarModuleStateError copyWith() {
    return const CalendarModuleStateError();
  }
}
