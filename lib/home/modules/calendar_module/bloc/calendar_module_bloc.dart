import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:studipadawan/home/modules/calendar_module/bloc/calendar_module_event.dart';
import 'package:studipadawan/home/modules/calendar_module/bloc/calendar_module_state.dart';
import 'package:studipadawan/home/modules/calendar_module/model/calendar_entry_preview.dart';

const int previewLimit = 4;
const int weeksLimit = 4;

class CalendarModuleBloc
    extends Bloc<CalendarModuleEvent, CalendarModuleState> {
  CalendarModuleBloc({
    required CalenderRepository calendarRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _calendarRepository = calendarRepository,
        _authenticationRepository = authenticationRepository,
        super(const CalendarModuleStateInitial()) {
    on<CalendarPreviewRequested>(_onCalendarPreviewRequested);
  }
  final CalenderRepository _calendarRepository;
  final AuthenticationRepository _authenticationRepository;

  Future<void> _onCalendarPreviewRequested(
    CalendarPreviewRequested event,
    Emitter<CalendarModuleState> emit,
  ) async {
    emit(const CalendarModuleStateLoading());
    try {
      final entries = await _fetchCalendarEntries();
      emit(
        CalendarModuleStateDidLoad(
          calendarEntries: entries.take(previewLimit).toList(),
        ),
      );
    } catch (_) {
      emit(const CalendarModuleStateError());
    }
  }

  Future<List<CalendarEntryPreview>> _fetchCalendarEntries() async {
    final entries = <CalendarEntryPreview>[];
    int week = 0;
    while (week < weeksLimit && entries.length <= previewLimit) {
      final calendarEntries = await _calendarRepository.getCalendarSchedule(
        userId: _authenticationRepository.currentUser.id,
        currentDateTime: DateTime.now().add(Duration(days: week * 7)),
      );
      final extractedEntries = _extractEntries(week, calendarEntries);
      entries.addAll(extractedEntries);
      week++;
    }
    return entries
      ..sort((entry1, entry2) => entry1.date.compareTo(entry2.date));
  }

  /// Extracts calendar entries for a given week from the provided calendarEntryData.
  /// The week parameter represents the week offset from the current week.
  /// The extracted entries are filtered based on their date, excluding any entries in the past.
  /// Returns a list of CalendarEntryPreview objects.
  List<CalendarEntryPreview> _extractEntries(
    int week,
    CalendarWeekData calendarEntryData,
  ) {
    final data = calendarEntryData.data;
    final entries = <CalendarEntryPreview>[];
    for (final value in data.values) {
      for (final timeframe in value.keys) {
        for (final entry in value[timeframe]!) {
          final int weekday = entry.weekday.index + 1;
          final DateTime date = CalendarEntryPreview.calculateDate(
            week,
            weekday,
            entry.timeframe.start,
          );
          if (date.isAfter(DateTime.now())) {
            entries.add(
              CalendarEntryPreview(
                day: weekday,
                title: entry.title,
                date: date,
                locations: entry.locations,
              ),
            );
          }
        }
      }
    }
    return entries;
  }
}
