import 'package:app_ui/app_ui.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:studipadawan/calendar/extensions/list_extensions.dart';
import 'package:studipadawan/calendar/widgets/calendar_timeframes_body/calendar_entry_layout.dart';

class CalendarTimeframesBody extends StatefulWidget {
  const CalendarTimeframesBody({
    super.key,
    required this.scheduleStructure,
    required this.scheduleData,
    required this.date,
  });
  final DateTime date;
  final List<CalendarTimeframe> scheduleStructure;
  final Map<Weekday, Map<String, List<CalendarEntryData>>> scheduleData;

  @override
  State<CalendarTimeframesBody> createState() => _CalendarTimeframesBodyState();
}

class _CalendarTimeframesBodyState extends State<CalendarTimeframesBody> {
  final controller = ItemScrollController();

  @override
  void initState() {
    /// Only scrolls to the specific time if the currentDate equals widget.date
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (DateTime.now().isSameDayAs(widget.date)) {
        final index = _findNearestIndexOfCalendarEntry();
        // Wenn die liste nicht mehr scrollbar ist wird einfach nur bis zum ende gescrollt
        controller.jumpTo(index: index);
        //TODO: scrollTo buggt
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final weekday = Weekday.fromIndex(widget.date.weekday - 1);

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.lg),
      child: ScrollablePositionedList.builder(
        itemCount: widget.scheduleStructure.length,
        itemScrollController: controller,
        itemBuilder: (context, index) {
          final key = widget.scheduleStructure[index].combinedKey();
          final entry = widget.scheduleData[weekday]?[key]?.firstOrNull();
          final nextTimeframe = index + 1 < widget.scheduleStructure.length
              ? widget.scheduleStructure[index + 1]
              : null;

          return CalendarEntryLayout(
            timeframe: widget.scheduleStructure[index],
            nextTimeframe: nextTimeframe,
            calendarEntryData: entry,
            showDivider: index != 0,
          );
        },
      ),
    );
  }

  int _findNearestIndexOfCalendarEntry() {
    final date = DateTime.now(); //DateTime(2023,4,20, 10,00); // 10:00 Uhr

    final currentTime = date.hourMinute;
    var previousHourMinute = HourMinute(hours: 0, minutes: 0);
    for (int i = 0; i < widget.scheduleStructure.length; i++) {
      final currentTimeframe = widget.scheduleStructure[i];
      final betweenTimeframe = CalendarTimeframe(
        start: previousHourMinute,
        end: currentTimeframe.start,
      );

      if (currentTimeframe.containsHourMinute(currentTime)) {
        return i;
      }
      if (betweenTimeframe.containsHourMinute(currentTime)) {
        return i == 0 ? 0 : i - 1;
      }

      previousHourMinute = currentTimeframe.end;
    }
    return widget.scheduleStructure.length - 1;
  }
}
