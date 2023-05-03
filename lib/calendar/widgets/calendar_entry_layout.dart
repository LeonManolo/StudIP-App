import 'package:calender_repository/calender_repository.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/calendar/widgets/calendar_entry.dart';
import 'package:studipadawan/calendar/widgets/calendar_entry_divider.dart';

import 'calendar_current_time_overlay.dart';
import 'empty_calendar_entry.dart';

class CalendarEntryLayout extends StatelessWidget {
  final CalendarEntryData? calendarEntryData;
  final CalendarTimeframe timeframe;

  const CalendarEntryLayout({
    Key? key,
    this.calendarEntryData,
    required this.timeframe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final leftSize = MediaQuery.of(context).size.width * 0.2;

    return Column(
      children: [
        CalendarEntry(
            color: Colors.green,
            calendarEntryData: calendarEntryData,
            timeFrame: timeframe),
        CalendarCurrentTimeOverlay(
          timeframe: CalendarTimeframe(start: HourMinute(hours: 9, minutes: 45), end: HourMinute(hours: 10, minutes: 0)),
          currentTime: HourMinute(hours: 9, minutes: 55),
          child: Container(
            color: Colors.amber.withOpacity(0.2),
            height: 50,
            width: double.infinity,
            //child: CalendarEntryDivider(paddingLeft: leftSize),
          ),
        ),
      ],
    );
  }
}
