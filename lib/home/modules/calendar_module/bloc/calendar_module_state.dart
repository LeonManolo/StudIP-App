import 'package:equatable/equatable.dart';
import 'package:studipadawan/home/modules/calendar_module/model/calendar_entry_preview.dart';

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
  const CalendarModuleStateDidLoad({
    this.calendarEntries = const [],
  });
  final List<CalendarEntryPreview> calendarEntries;
  @override
  List<Object?> get props => [calendarEntries];
}

class CalendarModuleStateError extends CalendarModuleState {
  const CalendarModuleStateError();

  @override
  List<Object?> get props => [];
}
