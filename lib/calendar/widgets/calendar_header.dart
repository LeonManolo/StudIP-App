import 'package:app_ui/app_ui.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    super.key,
    required this.calendarFormat,
    required this.selectedDay,
    required this.onDaySelected,
    required this.onFormatChanged,
  });
  final CalendarFormat calendarFormat;
  final DateTime selectedDay;
  final void Function(DateTime selectedDay) onDaySelected;
  final void Function(CalendarFormat selectedFormat) onFormatChanged;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Column(
      children: [
        TableCalendar<CalendarEntryData>(
          availableCalendarFormats: const {
            CalendarFormat.week: 'Woche',
            CalendarFormat.twoWeeks : '2 Wochen',
            CalendarFormat.month : 'Monat',
          },
          calendarBuilders: CalendarBuilders(
          ),
          locale: 'DE_de',
          calendarFormat: calendarFormat,
          onFormatChanged: onFormatChanged,
          calendarStyle: CalendarStyle(
            //outsideTextStyle: TextStyle(color: Colors.red),
            //rangeHighlightColor: Colors.red,
            selectedDecoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
            selectedTextStyle: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            todayDecoration: BoxDecoration(
              border: Border.all(
                color: primaryColor,
                width: 1.5,
              ),
              shape: BoxShape.circle,
            ),
            todayTextStyle: TextStyle(
              color: primaryColor,
              fontSize: 16,
            )

          ),
          focusedDay: selectedDay,
          selectedDayPredicate: (day) {
            return day.isSameDayAs(selectedDay);
          },
          startingDayOfWeek: StartingDayOfWeek.monday,
          currentDay: DateTime.now(),
          firstDay: DateTime.now().subtract(const Duration(days: 90)),
          lastDay: DateTime.now().add(const Duration(days: 90)),
          onDaySelected: (newSelectedDay, _) => onDaySelected(newSelectedDay),
        ),
        const Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Divider(),
        ),
      ],
    );
  }
}
