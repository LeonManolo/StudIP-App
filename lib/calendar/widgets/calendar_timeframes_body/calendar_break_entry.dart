import 'package:app_ui/app_ui.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/calendar/widgets/calendar_timeframes_body/calendar_current_time_overlay.dart';
import 'package:studipadawan/calendar/widgets/calendar_timeframes_body/calendar_entry_divider.dart';

class CalendarBreakEntry extends StatelessWidget {

  const CalendarBreakEntry({
    super.key,
    this.breakStart,
    this.breakEnd,
    required this.currentTime,
    required this.breakWidgetKey,
  });
  final HourMinute? breakStart;
  final HourMinute? breakEnd;
  final HourMinute currentTime;
  final GlobalKey breakWidgetKey;

  @override
  Widget build(BuildContext context) {
    if (breakEnd == null || breakStart == null) {
      return const SizedBox();
    }

    final paddingLeft = MediaQuery.of(context).size.width * 0.2;

    return CalendarCurrentTimeOverlay(
      excludingEqualTimes: true,
      rowKey: breakWidgetKey,
      timeframe: CalendarTimeframe(start: breakStart!, end: breakEnd!),
      currentTime: currentTime,
      child: Container(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
        height: 50,
        width: double.infinity,
        alignment: Alignment.bottomCenter,
        child: CalendarEntryDivider(paddingLeft: paddingLeft),
      ),
    );
  }
}
