import 'package:app_ui/app_ui.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:flutter/material.dart';

/// Left side of the Calendar entry, shows the start and (end) time of an event
class CalendarEntryTime extends StatelessWidget {
  const CalendarEntryTime({
    super.key,
    required this.timeframe,
    required this.width,
    required this.calendarEntryTimeKey,
    required this.showCalendarTimes,
  });

  final GlobalKey calendarEntryTimeKey;
  final CalendarTimeframe timeframe;
  final bool showCalendarTimes;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            timeframe.start.toString(),
            key: calendarEntryTimeKey,
            style: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                    color: showCalendarTimes
                        ? context.adaptiveTextColor
                        : Colors.transparent,
                  )
                  .color,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
