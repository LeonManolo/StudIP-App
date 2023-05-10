import 'package:app_ui/app_ui.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/calendar/widgets/calendar_entry_content.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar2 extends StatelessWidget {
  const Calendar2({
    super.key,
    required this.scheduleData,
    required this.selectedDay,
    required this.onDaySelected,
  });

  final DateTime selectedDay;
  final Map<Weekdays, List<CalendarEntryData>> scheduleData;
  final void Function(DateTime selectedDay) onDaySelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar<CalendarEntryData>(
          calendarFormat: CalendarFormat.week,
          calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          focusedDay: selectedDay,
          selectedDayPredicate: (day) {
            return day.isSameDayAs(selectedDay);
          },
          startingDayOfWeek: StartingDayOfWeek.monday,
          currentDay: DateTime.now(),
          firstDay: DateTime.now().subtract(const Duration(days: 90)),
          lastDay: DateTime.now().add(const Duration(days: 90)),
          onDaySelected: (selectedDay, focusedDay) {
            onDaySelected(selectedDay);
          },
        ),
        const Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Divider(),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: ListView.separated(
            itemCount: scheduleData[
                        Weekdays.indexToWeekday(selectedDay.weekday - 1)]
                    ?.length ??
                0,
            separatorBuilder: (_, __) {
              return const Padding(padding: EdgeInsets.only(bottom: AppSpacing.lg));
            },
            itemBuilder: (context, index) {
              return CalendarEntryContent(
                timeframe: CalendarTimeframe(
                  start: HourMinute(hours: 8, minutes: 15),
                  end: HourMinute(hours: 9, minutes: 45),
                ),
                calendarEntryData: scheduleData[
                        Weekdays.indexToWeekday(selectedDay.weekday - 1)]
                    ?[index],
              );
            },
          ),
        ))
      ],
    );
  }
}
