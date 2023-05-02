import 'package:authentication_repository/authentication_repository.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:studipadawan/calendar/bloc/calendar_bloc.dart';
import 'package:studipadawan/calendar/bloc/calendar_state.dart';
import 'package:studipadawan/calendar/widgets/calendar.dart';
import 'package:studipadawan/calendar/widgets/calendar_header.dart';

import '../bloc/calendar_event.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kalender"),
      ),
      body: BlocProvider(
        create: (ctx) => CalendarBloc(
          calendarRepository: context.read<CalenderRepository>(),
          authenticationRepository: context.read<AuthenticationRepository>(),
        )..add(CalendarRequested(day: DateTime.now())),
        child: BlocConsumer<CalendarBloc, CalendarState>(
          listener: (context, state) {
            if (state is CalendarFailure) {
              var snackBar = SnackBar(content: Text(state.failureMessage));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          builder: (context, state) {
            if (state is CalendarLoading) {
              return Center(
                  child: SpinKitThreeBounce(
                size: 25,
                color: Theme.of(context).primaryColor,
              ));
            }
            if (state is CalendarPopulated) {
              return Calendar(
                onDaySelected: (day) {
                  context
                      .read<CalendarBloc>()
                      .add(CalendarExactDayRequested(exactDay: day));
                },
                onNextButtonPress: () {
                  context
                      .read<CalendarBloc>()
                      .add(const CalendarNextDayRequested());
                },
                onPreviousButtonPress: () {
                  context
                      .read<CalendarBloc>()
                      .add(const CalendarPreviousDayRequested());
                },
                date: state.currentDay,
                scheduleData: state.calendarWeekData.data,
                currentHourMinute: HourMinute(hours: 8, minutes: 45),
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
              );
            }

            if (state is CalendarFailure) {
              return Text(state.failureMessage);
            }
            return const Text("nothing");
          },
        ),
      ),
    );
  }
}
