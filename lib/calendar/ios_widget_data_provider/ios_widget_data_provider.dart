import 'package:authentication_repository/authentication_repository.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:studipadawan/utils/casting.dart';

class IOSWidgetDataProvider {
  IOSWidgetDataProvider({
    required CalenderRepository calendarRepository,
    required AuthenticationRepository authRepository,
  })  : _calendarRepository = calendarRepository,
        _authRepository = authRepository,
        _methodChannel = const MethodChannel(
          'de.hsflensburg.studipadawan.calendarCommunication',
        ) {
    _addMethodChannelListener();
  }

  final CalenderRepository _calendarRepository;
  final AuthenticationRepository _authRepository;
  final MethodChannel _methodChannel;

  void _addMethodChannelListener() {
    _methodChannel.setMethodCallHandler(
      (call) async {
        switch (call.method) {
          case 'loadWidgetCalendarEvents':
            final String? startDate =
                castOrNull<String>(call.arguments['requestedDateTime']);
            if (startDate != null) {
              final serializedJsonResponse =
                  await _handleLoadWidgetCalendarEvents(
                requestedDateTimeIso8601String: startDate,
              );
              return serializedJsonResponse;
            } else {
              Logger().e(
                'Parameter requestedDateTime is missing or in wrong format.',
              );
              return 'An error occured';
            }

          default:
            Logger().d('Invalid method name: ${call.method}');
        }
      },
    );
  }

  Future<String?> _handleLoadWidgetCalendarEvents({
    required String requestedDateTimeIso8601String,
  }) async {
    final DateTime parsedDateTime =
        DateTime.parse(requestedDateTimeIso8601String);
    if (_authRepository.currentUser.isEmpty) return null;

    final calendarWeekData = await _calendarRepository.getCalenderSchedule(
      userId: _authRepository.currentUser.id,
      dateTime: parsedDateTime,
    );

    return calendarWeekData.data.entries
        .map((weekday) => weekday.key.name)
        .join(',');
  }
}
