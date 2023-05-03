import 'package:calender_repository/calender_repository.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/calendar/widgets/calendar_entry.dart';
import 'package:studipadawan/calendar/widgets/calendar_entry_divider.dart';

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
        // SizedBox(
        //   height: 50,
        //   width: double.infinity,
        //   child: CalendarEntryDivider(paddingLeft: leftSize),
        // ),
      ],
    );
  }
}
