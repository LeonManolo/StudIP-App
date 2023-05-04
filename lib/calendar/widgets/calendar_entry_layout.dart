import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/calendar/widgets/calendar_entry.dart';
import 'package:studipadawan/calendar/widgets/calendar_entry_divider.dart';

import 'calendar_current_time_overlay.dart';
import 'empty_calendar_entry.dart';

class CalendarEntryLayout extends StatefulWidget {
  final CalendarEntryData? calendarEntryData;
  final CalendarTimeframe timeframe;
  final CalendarTimeframe? nextTimeframe;
  final bool showDivider;

  const CalendarEntryLayout({
    Key? key,
    this.calendarEntryData,
    required this.timeframe,
    this.nextTimeframe,
    required this.showDivider,
  }) : super(key: key);

  @override
  State<CalendarEntryLayout> createState() => _CalendarEntryLayoutState();
}

class _CalendarEntryLayoutState extends State<CalendarEntryLayout> {
  final startTimeKey = GlobalKey();
  final currentTimeIndicatorKey = GlobalKey();
  final breakWidgetKey = GlobalKey();
  var hourMinute = HourMinute(hours: 9, minutes: 43);
  static const timerInterval = Duration(seconds: 1);

  Timer? timer;

  double opacity = 1;

  @override
  void initState() {
    initTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final leftSize = MediaQuery.of(context).size.width * 0.2;
    updateOpacity();

    return Column(
      children: [
        CalendarEntry(
            currentTime: hourMinute,
            opacity: opacity,
            textKey: startTimeKey,
            rowKey: currentTimeIndicatorKey,
            color: Colors.green,
            calendarEntryData: widget.calendarEntryData,
            timeFrame: widget.timeframe),
        LayoutBuilder(builder: (_, __) {
          if (widget.nextTimeframe == null) {
            return const SizedBox();
          }
          final timeframe = CalendarTimeframe(
            start: widget.timeframe.end,
            end: widget.nextTimeframe!.start,
          );
          return CalendarCurrentTimeOverlay(
            excludingEqualTimes: true,
            rowKey: breakWidgetKey,
            timeframe: timeframe,
            currentTime: hourMinute,
            child: Container(
              //color: Colors.amber.withOpacity(0.2),
              padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
              height: 50,
              width: double.infinity,
              alignment: Alignment.bottomCenter,
              child: CalendarEntryDivider(paddingLeft: leftSize),
              //child: CalendarEntryDivider(paddingLeft: leftSize),
            ),
          );
        }),
      ],
    );
  }

  //TODO: timer optimieren (in das calendar widget ziehen um nur ein timer zu haben, ein stream bei dem alle widgets listen (events nur von 8:15 - 20:45 emitten)
  void initTimer() {
    Timer.periodic(timerInterval, (timer) {
      if (!mounted) return;
      setState(() {
        hourMinute = hourMinute.addMinutes(1);
        print(hourMinute);
      });
    });
  }

  bool checkOverlap(GlobalKey key1, GlobalKey key2) {
    if (key1.currentContext == null || key2.currentContext == null) {
      return false;
    }
    final RenderBox box1 = key1.currentContext!.findRenderObject() as RenderBox;
    final RenderBox box2 = key2.currentContext!.findRenderObject() as RenderBox;

    final rect1 = box1.localToGlobal(Offset.zero) & box1.size;
    final rect2 = box2.localToGlobal(Offset.zero) & box2.size;

    print("overlapping: ${rect1.overlaps(rect2)}");
    return rect1.overlaps(rect2);
  }

  void updateOpacity() {
    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final overlapping = checkOverlap(startTimeKey, currentTimeIndicatorKey);
      final newOpacity = overlapping ? 0.0 : 1.0;
      if (newOpacity != opacity && mounted) {
        setState(() {
          opacity = newOpacity;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
