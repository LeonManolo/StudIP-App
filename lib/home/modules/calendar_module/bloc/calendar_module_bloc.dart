import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:logger/logger.dart';
import 'package:studipadawan/home/modules/bloc/module_bloc.dart';
import 'package:studipadawan/home/modules/calendar_module/model/calendar_preview_model.dart';

const int weeksLimit = 4;

class CalendarModuleBloc extends ModuleBloc {
  CalendarModuleBloc({
    required CalenderRepository calendarRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _calendarRepository = calendarRepository,
        _authenticationRepository = authenticationRepository,
        super();

  final CalenderRepository _calendarRepository;
  final AuthenticationRepository _authenticationRepository;

  @override
  String get emptyViewMessage =>
      'Für die nächsten 4 Wochen sind keine Kalendereinträge vorhanden.';

  @override
  Future<void> onModuleItemsRequested(
    ModuleItemsRequested event,
    Emitter<ModuleState> emit,
  ) async {
    try {
      final entries = await _fetchCalendarEntries();
      emit(ModuleLoaded(previewModels: entries.take(previewLimit).toList()));
    } catch (e) {
      Logger().e(e);
      emit(
        const ModuleError(
          errorMessage: 'Beim Laden der Termine ist ein Fehler aufgetreten.',
        ),
      );
    }
  }

  Future<List<CalendarPreviewModel>> _fetchCalendarEntries() async {
    final entries = <CalendarPreviewModel>[];
    int week = 0;
    while (week < weeksLimit && entries.length <= previewLimit) {
      final calendarEntries = await _calendarRepository.getCalendarSchedule(
        userId: _authenticationRepository.currentUser.id,
        requestedDateTime: DateTime.now().add(Duration(days: week * 7)),
      );
      final extractedEntries = _extractEntries(week, calendarEntries);
      entries.addAll(extractedEntries);
      week++;
    }
    return entries
      ..sort((entry1, entry2) =>
          entry1.entryStartDate.compareTo(entry2.entryStartDate));
  }

  /// Extracts calendar entries for a given week from the provided calendarEntryData.
  /// The week parameter represents the week offset from the current week.
  /// The extracted entries are filtered based on their date, excluding any entries in the past.
  /// Returns a list of CalendarEntryPreview objects.
  List<CalendarPreviewModel> _extractEntries(
    int week,
    CalendarWeekData calendarEntryData,
  ) {
    final data = calendarEntryData.data;
    final entries = <CalendarPreviewModel>[];
    for (final value in data.values) {
      for (final timeframe in value.keys) {
        for (final entry in value[timeframe]!) {
          final int weekday = entry.weekday.index + 1;
          final DateTime date = CalendarPreviewModel.calculateDate(
            week,
            weekday,
            entry.timeframe.start,
          );
          if (date.isAfter(DateTime.now())) {
            entries.add(
              CalendarPreviewModel(
                day: weekday,
                entryTitle: entry.title,
                entryStartDate: date,
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
