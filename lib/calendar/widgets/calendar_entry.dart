import 'package:calender_repository/calender_repository.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/calendar/widgets/calendar_current_time_overlay.dart';
import 'package:studipadawan/calendar/widgets/calendar_entry_content.dart';
import 'package:studipadawan/calendar/widgets/calendar_entry_time.dart';

import 'calendar_entry_divider.dart';

class CalendarEntry extends StatefulWidget {
  final CalendarEntryData? calendarEntryData;
  final bool showDivider;
  final Color color;
  final CalendarTimeframe timeFrame;
  final double opacity;
  final HourMinute currentTime;

  final GlobalKey currentTimeIndicatorKey;
  final GlobalKey calendarEntryTimeKey;

  const CalendarEntry(
      {Key? key,
      required this.timeFrame,
      this.showDivider = true,
      this.calendarEntryData,
      required this.color,
      required this.currentTimeIndicatorKey,
      required this.calendarEntryTimeKey,
      required this.opacity,
      required this.currentTime})
      : super(key: key);

  @override
  State<CalendarEntry> createState() => _CalendarEntryState();
}

class _CalendarEntryState extends State<CalendarEntry> {
  @override
  Widget build(BuildContext context) {
    final leftSize = MediaQuery.of(context).size.width * 0.2;

    return CalendarCurrentTimeOverlay(
      rowKey: widget.currentTimeIndicatorKey,
      timeframe: widget.timeFrame,
      currentTime: widget.currentTime,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              CalendarEntryTime(
                  timeframe: widget.timeFrame,
                  width: leftSize,
                  calendarEntryTimeKey: widget.calendarEntryTimeKey,
                  showCalendarTimes: widget.opacity == 1),
              Expanded(
                child: CalendarEntryContent(
                    calendarEntryData: widget.calendarEntryData,
                    timeframe: widget.timeFrame),
              ),
            ],
          ),
          if (widget.showDivider) CalendarEntryDivider(paddingLeft: leftSize),
        ],
      ),
    );
  }
}
