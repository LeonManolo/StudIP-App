import 'package:animate_do/animate_do.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:studipadawan/calendar/bloc/calendar_bloc.dart';
import 'package:studipadawan/calendar/bloc/calendar_event.dart';
import 'package:studipadawan/calendar/bloc/calendar_state.dart';
import 'package:studipadawan/calendar/calendar_notifications/view/calendar_schedule_notifications_page.dart';
import 'package:studipadawan/calendar/widgets/calendar_header.dart';
import 'package:studipadawan/calendar/widgets/calendar_list_body/calendar_list_body.dart';
import 'package:studipadawan/calendar/widgets/calendar_timeframes_body/calendar_timeframes_body.dart';
import 'package:studipadawan/utils/widgets/error_view/error_view.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key, required this.calendarBloc});

  final CalendarBloc calendarBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalender'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<CalendarScheduleNotificationsPage>(
                  builder: (context) =>
                      const CalendarScheduleNotificationsPage(),
                ),
              );
            },
            icon: const Icon(EvaIcons.bellOutline),
          ),
          IconButton(
            onPressed: () {
              calendarBloc.add(const CalendarSwitchLayoutRequested());
            },
            icon: BlocBuilder<CalendarBloc, CalendarState>(
              bloc: calendarBloc,
              buildWhen: (previous, current) {
                return previous.layout != current.layout;
              },
              builder: (context, state) {
                Color? color;
                if (calendarBloc.state.layout == CalendarBodyType.timeframes) {
                  color = Theme.of(context).primaryColor;
                }
                return Spin(
                  duration: const Duration(milliseconds: 800),
                  key: GlobalKey(),
                  child: Icon(
                    EvaIcons.repeatOutline,
                    color: color,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          BlocBuilder<CalendarBloc, CalendarState>(
            builder: (context, state) {
              return CalendarHeader(
                onDaySelected: (day) {
                  calendarBloc.add(CalendarExactDayRequested(exactDay: day));
                },
                onFormatChanged: (selectedFormat) {
                  calendarBloc.add(
                    CalendarFormatChangeRequest(
                      CalendarFormat.fromTableCalendarFormat(
                        format: selectedFormat,
                      ),
                    ),
                  );
                },
                selectedDay: state.currentDay,
                calendarFormat: state.calendarFormat.toTableCalendarFormat(),
              );
            },
          ),
          Expanded(
            child: BlocConsumer<CalendarBloc, CalendarState>(
              bloc: calendarBloc,
              listener: (context, state) {
                if (state is CalendarFailure) {
                  final snackBar =
                      SnackBar(content: Text(state.failureMessage));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              builder: (context, state) {
                switch (state) {
                  case CalendarLoading _:
                    return Center(
                      child: SpinKitThreeBounce(
                        size: 25,
                        color: Theme.of(context).primaryColor,
                      ),
                    );

                  case CalendarPopulated _:
                    final day = Weekday.fromIndex(state.currentDay.weekday - 1);
                    final calendarWeekData = _transformCalendarData(state);
                    final calendarDayData = calendarWeekData[day] ?? [];

                    if (state.layout == CalendarBodyType.list) {
                      return CalendarListBody(
                        selectedDay: state.currentDay,
                        scheduleData: calendarDayData,
                      );
                    } else {
                      return FadeInDown(
                        from: -200,
                        key: GlobalKey(),
                        child: CalendarTimeframesBody(
                          date: state.currentDay,
                          scheduleData: state.calendarWeekData.data,
                          scheduleStructure: _calendarSchedule(),
                        ),
                      );
                    }

                  case CalendarFailure(
                      currentDay: final day,
                    ):
                    return ErrorView(
                      message:
                          'Es ist ein Fehler beim Laden des Stundenplan aufgetreten. Versuche es später erneut.',
                      marginTop: 0,
                      onRetryPressed: () {
                        calendarBloc
                            .add(CalendarExactDayRequested(exactDay: day));
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Map<Weekday, List<CalendarEntryData>> _transformCalendarData(
    CalendarPopulated state,
  ) {
    return state.calendarWeekData.data.map(
      (key, value) => MapEntry(
        key,
        value.values.fold<List<CalendarEntryData>>([],
            (previousValue, current) {
          final newList = previousValue;

          for (int i = 0; i < current.length; i++) {
            newList.insertAndMaintainSortOrder(current.elementAt(i));
          }

          return newList;
        }),
      ),
    );
  }

  List<CalendarTimeframe> _calendarSchedule() {
    return [
      CalendarTimeframe(
        start: HourMinute(hours: 8, minutes: 15),
        end: HourMinute(hours: 9, minutes: 45),
      ),
      CalendarTimeframe(
        start: HourMinute(hours: 10, minutes: 0),
        end: HourMinute(hours: 11, minutes: 30),
      ),
      CalendarTimeframe(
        start: HourMinute(hours: 12, minutes: 15),
        end: HourMinute(hours: 13, minutes: 45),
      ),
      CalendarTimeframe(
        start: HourMinute(hours: 14, minutes: 0),
        end: HourMinute(hours: 15, minutes: 30),
      ),
      CalendarTimeframe(
        start: HourMinute(hours: 15, minutes: 45),
        end: HourMinute(hours: 17, minutes: 15),
      ),
      CalendarTimeframe(
        start: HourMinute(hours: 17, minutes: 30),
        end: HourMinute(hours: 19, minutes: 0),
      ),
      CalendarTimeframe(
        start: HourMinute(hours: 19, minutes: 15),
        end: HourMinute(hours: 20, minutes: 45),
      ),
    ];
  }
}
