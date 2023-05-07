import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:studipadawan/calendar/widgets/calendar_header.dart';

import 'calendar_entry_layout.dart';

class Calendar extends StatefulWidget {
  final DateTime date;
  final List<CalendarTimeframe> scheduleStructure;
  final Map<Weekdays, Map<String, CalendarEntryData>> scheduleData;
  final VoidCallback onPreviousButtonPress;
  final VoidCallback onNextButtonPress;
  final Function(DateTime) onDaySelected;

  const Calendar({
    Key? key,
    required this.scheduleStructure,
    required this.scheduleData,
    required this.date,
    required this.onPreviousButtonPress,
    required this.onNextButtonPress,
    required this.onDaySelected,
  }) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
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
    final weekday = Weekdays.indexToWeekday(widget.date.weekday - 1);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CalendarHeader(
          onDatePress: () => _openDatePicker(context),
          dateTime: widget.date,
          onPreviousButtonPress: widget.onPreviousButtonPress,
          onNextButtonPress: widget.onNextButtonPress,
        ),
        Expanded(
          child: ScrollablePositionedList.builder(
              itemCount: widget.scheduleStructure.length,
              itemScrollController: controller,
              itemBuilder: (context, index) {
                final key = widget.scheduleStructure[index].combinedKey();
                final entry = widget.scheduleData[weekday]?[key];
                final nextTimeframe =
                    index + 1 < widget.scheduleStructure.length
                        ? widget.scheduleStructure[index + 1]
                        : null;

                return CalendarEntryLayout(
                  timeframe: widget.scheduleStructure[index],
                  nextTimeframe: nextTimeframe,
                  calendarEntryData: entry,
                  showDivider: index != 0,
                );
              }),
        ),
      ],
    );
  }

  Future<void> _openDatePicker(BuildContext context) async {
    final results = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.single,
      ),
      dialogSize: const Size(325, 400),
      borderRadius: BorderRadius.circular(15),
    );
    if (results?.length == 1) {
      widget.onDaySelected(results!.first!);
    }
  }

  int _findNearestIndexOfCalendarEntry() {
    final date = DateTime.now(); //DateTime(2023,4,20, 10,00); // 10:00 Uhr

    final currentTime = date.hourMinute;
    var previousHourMinute = HourMinute(hours: 0, minutes: 0);
    for (int i = 0; i < widget.scheduleStructure.length; i++) {
      final currentTimeframe = widget.scheduleStructure[i];
      final betweenTimeframe = CalendarTimeframe(
          start: previousHourMinute, end: currentTimeframe.start);

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
