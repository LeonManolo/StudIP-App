import 'dart:async';

import 'package:calender_repository/calender_repository.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/calendar/widgets/calendar_entry.dart';
import 'package:studipadawan/calendar/widgets/calendar_entry_divider.dart';

import 'calendar_current_time_overlay.dart';
import 'empty_calendar_entry.dart';

class CalendarEntryLayout extends StatefulWidget {
  final CalendarEntryData? calendarEntryData;
  final CalendarTimeframe timeframe;

  const CalendarEntryLayout({
    Key? key,
    this.calendarEntryData,
    required this.timeframe,
  }) : super(key: key);

  @override
  State<CalendarEntryLayout> createState() => _CalendarEntryLayoutState();
}

class _CalendarEntryLayoutState extends State<CalendarEntryLayout> {
  final textKey = GlobalKey();
  final rowKey = GlobalKey();
  final breakWidgetKey = GlobalKey();
  var hourMinute = HourMinute(hours: 8, minutes: 18);

  Timer? timer;

  double opacity = 1;

  @override
  void initState() {
    initTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    updateOpacity();

    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              print("refresh");
              hourMinute = HourMinute(hours: 9, minutes: 10);
            });
          },
          child: CalendarEntry(
            currentTime: hourMinute,
            opacity: opacity,
            textKey: textKey,
              rowKey: rowKey,
              color: Colors.green,
              calendarEntryData: widget.calendarEntryData,
              timeFrame: widget.timeframe),
        ),
        CalendarCurrentTimeOverlay(
          rowKey: breakWidgetKey,
          timeframe: CalendarTimeframe(start: HourMinute(hours: 9, minutes: 45), end: HourMinute(hours: 10, minutes: 0)),
          currentTime: hourMinute,
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

  void initTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if(!mounted) return;
      setState(() {
        hourMinute = hourMinute.addMinutes(1);
        print(hourMinute);
      });
    });
  }

  bool checkOverlap(GlobalKey key1, GlobalKey key2) {
    if(key1.currentContext == null || key2.currentContext == null) {
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
    if(!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final overlapping = checkOverlap(textKey, rowKey);
      final newOpacity = overlapping ? 0.0 : 1.0;
      if(newOpacity != opacity && mounted) {
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
