import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:app_ui/app_ui.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:studipadawan/calendar/bloc/calendar_bloc.dart';
import 'package:studipadawan/calendar/bloc/calendar_event.dart';
import 'package:studipadawan/calendar/bloc/calendar_state.dart';
import 'package:studipadawan/calendar/calendar_notifications/view/calendar_schedule_notifications_page.dart';
import 'package:studipadawan/calendar/widgets/calendar_header.dart';
import 'package:studipadawan/calendar/widgets/calendar_list_body/calendar_list_body.dart';
import 'package:studipadawan/calendar/widgets/calendar_timeframes_body/calendar_timeframes_body.dart';

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
          layout: CalendarBodyType.list,
        ),
      );

    return BlocProvider(
      create: (_) => calendarBloc,
      child: PlatformScaffold(
        iosContentPadding: true,
        iosContentBottomPadding: true,
        appBar: PlatformAppBar(
          //backgroundColor: Platform.isIOS ? Theme.of(context).scaffoldBackgroundColor : null,
          title: const Text('Kalender'),
          trailingActions: [
            AdaptiveAppBarIconButton(
                cupertinoIcon: CupertinoIcons.bell,
                materialIcon: EvaIcons.bellOutline,
                onPressed: () {
                  Navigator.of(context).push(CalendarScheduleNotificationsPage.page().createRoute(context));
                },
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
                  if (calendarBloc.state.layout ==
                      CalendarBodyType.timeframes) {
                    color = context.adaptivePrimaryColor;
                  }
                  return Spin(
                    duration: const Duration(milliseconds: 800),
                    key: GlobalKey(),
                    child: Icon(
                      Platform.isIOS ? CupertinoIcons.arrow_2_circlepath_circle : EvaIcons.repeatOutline,
                      color: color,
                      size: Platform.isIOS ? 27 : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            CalendarHeader(
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
                        color: context.adaptivePrimaryColor,
                      ),
                    );
                  }
                  if (state is CalendarPopulated) {
                    final day =
                        Weekdays.indexToWeekday(state.currentDay.weekday - 1);
                    final calendarWeekData = _transformCalendarData(state);
                    final calendarDayData = calendarWeekData[day] ?? [];

                    if (state.layout == CalendarBodyType.list) {
                      return CalendarListBody(
                        selectedDay: state.currentDay,
                        scheduleData: calendarDayData,
                      );
                    }

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

  Map<Weekdays, List<CalendarEntryData>> _transformCalendarData(
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
