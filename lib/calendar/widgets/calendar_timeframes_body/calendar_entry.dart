import 'package:calender_repository/calender_repository.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/calendar/widgets/calendar_entry_content.dart';
import 'package:studipadawan/calendar/widgets/calendar_timeframes_body/calendar_entry_divider.dart';

import 'calendar_current_time_overlay.dart';
import 'calendar_entry_time.dart';

class CalendarEntry extends StatefulWidget {
  const CalendarEntry({
    super.key,
    required this.timeFrame,
    this.showDivider = true,
    this.padding = 0,
    this.calendarEntryData,
    required this.color,
    required this.currentTimeIndicatorKey,
    required this.calendarEntryTimeKey,
    required this.opacity,
    required this.currentTime,
  });

  final CalendarEntryData? calendarEntryData;
  final double padding;
  final bool showDivider;
  final Color color;
  final CalendarTimeframe timeFrame;
  final double opacity;
  final HourMinute currentTime;

  final GlobalKey currentTimeIndicatorKey;
  final GlobalKey calendarEntryTimeKey;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CalendarEntryTime(
                timeframe: widget.timeFrame,
                width: leftSize,
                calendarEntryTimeKey: widget.calendarEntryTimeKey,
                showCalendarTimes: widget.opacity == 1,
              ),
              Expanded(
                child: CalendarEntryContent(
                  padding: widget.padding,
                  calendarEntryData: widget.calendarEntryData,
                  timeframe: widget.timeFrame,
                  backgroundColor: widget.color,
                ),
              ),
            ],
          ),
          if (widget.showDivider) CalendarEntryDivider(paddingLeft: leftSize),
        ],
      ),
    );
  }
}
