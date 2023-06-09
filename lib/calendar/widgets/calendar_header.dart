import 'package:app_ui/app_ui.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// class CalendarHeader extends StatefulWidget {
//   const CalendarHeader({super.key, required this.onDaySelected, required this.initialSelectedDay});

//   final void Function(DateTime selectedDay) onDaySelected;
//   final DateTime initialSelectedDay;

//   @override
//   State<CalendarHeader> createState() => _CalendarHeaderState();
// }

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
    return Column(
      children: [
        TableCalendar<CalendarEntryData>(
          locale: 'DE_de',
          calendarFormat: calendarFormat,
          onFormatChanged: onFormatChanged,
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
