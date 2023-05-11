import 'package:animate_do/animate_do.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:studipadawan/calendar/bloc/calendar_bloc.dart';
import 'package:studipadawan/calendar/bloc/calendar_event.dart';
import 'package:studipadawan/calendar/bloc/calendar_state.dart';
import 'package:studipadawan/calendar/widgets/calendar.dart';
import 'package:studipadawan/calendar/widgets/calendar_2.dart';
import 'package:studipadawan/calendar/widgets/calendar_header_2.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final calendarBloc = CalendarBloc(
      calendarRepository: context.read<CalenderRepository>(),
      authenticationRepository: context.read<AuthenticationRepository>(),
    )..add(
        CalendarRequested(
          day: DateTime.now(),
          layout: CalendarLayout.withoutTimeIndicators,
        ),
      );

    return BlocProvider(
      create: (_) => calendarBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kalender'),
          actions: [
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
                  if (calendarBloc.state.layout ==
                      CalendarLayout.withTimeIndicators) {
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
            CalendarHeader2(
              onDaySelected: (day) {
                calendarBloc.add(CalendarExactDayRequested(exactDay: day));
              },
              initialSelectedDay: DateTime.now(),
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
                  if (state is CalendarLoading) {
                    return Center(
                      child: SpinKitThreeBounce(
                        size: 25,
                        color: Theme.of(context).primaryColor,
                      ),
                    );
                  }
                  if (state is CalendarPopulated) {
                    final calendar2Data = transformCalendarData(state);

                    if (state.layout == CalendarLayout.withoutTimeIndicators) {
                      return Calendar2(
                        selectedDay: state.currentDay,
                        scheduleData: calendar2Data,
                      );
                    }

                    return FadeInDown(
                      from: -200,
                      key: GlobalKey(),
                      child: Calendar(
                        date: state.currentDay,
                        scheduleData: state.calendarWeekData.data,
                        scheduleStructure: [
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
                        ],
                      ),
                    );
                  }

                  if (state is CalendarFailure) {
                    return Text(state.failureMessage);
                  }
                  return const Text('nothing');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<Weekdays, List<CalendarEntryData>> transformCalendarData(
    CalendarPopulated state,
  ) {
    return state.calendarWeekData.data.map(
      (key, value) => MapEntry(
        key,
        value.values.fold<List<CalendarEntryData>>(
          [],
          (previousValue, current) =>
              previousValue.followedBy(current).toList(),
        ),
      ),
    );
  }
}
