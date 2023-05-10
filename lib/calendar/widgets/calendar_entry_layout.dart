import 'dart:async';
import 'package:calender_repository/calender_repository.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/calendar/widgets/calendar_break_entry.dart';
import 'package:studipadawan/calendar/widgets/calendar_entry.dart';

class CalendarEntryLayout extends StatefulWidget {
  const CalendarEntryLayout({
    super.key,
    this.calendarEntryData,
    required this.timeframe,
    this.nextTimeframe,
    required this.showDivider,
  });

  final CalendarEntryData? calendarEntryData;
  final CalendarTimeframe timeframe;
  final CalendarTimeframe? nextTimeframe;
  final bool showDivider;

  @override
  State<CalendarEntryLayout> createState() => _CalendarEntryLayoutState();
}

class _CalendarEntryLayoutState extends State<CalendarEntryLayout> {
  final startTimeKey = GlobalKey();
  final currentTimeIndicatorKey = GlobalKey();
  final breakWidgetKey = GlobalKey();
  HourMinute currentHourMinute = HourMinute.fromDateTime(dateTime: DateTime.now());
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
    updateOpacity();

    return Column(
      children: [
        CalendarEntry(
          currentTime: currentHourMinute,
          opacity: opacity,
          calendarEntryTimeKey: startTimeKey,
          currentTimeIndicatorKey: currentTimeIndicatorKey,
          color: Theme.of(context).primaryColor,
          calendarEntryData: widget.calendarEntryData,
          timeFrame: widget.timeframe,
        ),
        CalendarBreakEntry(
          breakStart: widget.timeframe.end,
          breakEnd: widget.nextTimeframe?.start,
          currentTime: currentHourMinute,
          breakWidgetKey: breakWidgetKey,
        ),
      ],
    );
  }

  /// Initializes a timer to update the currentHourMinute periodically.
  //TODO: timer optimieren (in das calendar widget ziehen um nur ein timer zu haben, ein stream bei dem alle widgets listen (events nur von 8:15 - 20:45 emitten)
  void initTimer() {
    Timer.periodic(timerInterval, (timer) {
      if (!mounted) return;
      //final forTesting = currentHourMinute.addMinutes(1);
      final newTime = HourMinute.fromDateTime(dateTime: DateTime.now());
      if (!newTime.equals(currentHourMinute)) {
        setState(() {
          currentHourMinute = newTime;
          //print(currentHourMinute);
        });
      }
    });
  }

  /// Checks if two widgets with the given global keys overlap in their rendered layout.
  ///
  /// @param key1 GlobalKey of the first widget.
  /// @param key2 GlobalKey of the second widget.
  /// @return `true` if the widgets overlap, `false` otherwise.
  bool checkOverlap(GlobalKey key1, GlobalKey key2) {
    final RenderBox? box1 =
        key1.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? box2 =
        key2.currentContext?.findRenderObject() as RenderBox?;

    if (box1 != null && box2 != null) {
      final rect1 = box1.localToGlobal(Offset.zero) & box1.size;
      final rect2 = box2.localToGlobal(Offset.zero) & box2.size;

      return rect1.overlaps(rect2);
    } else {
      return false;
    }
  }

  /// Updates the opacity value based on the overlap between the startTimeKey and currentTimeIndicatorKey.
  /// Depending on the outcome the calendar times are visible or not
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

  /// Disposes the timer
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
