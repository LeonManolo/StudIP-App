import 'package:app_ui/app_ui.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarHeader2 extends StatefulWidget {
  const CalendarHeader2({super.key, required this.onDaySelected, required this.initialSelectedDay});

  final void Function(DateTime selectedDay) onDaySelected;
  final DateTime initialSelectedDay;


  @override
  State<CalendarHeader2> createState() => _CalendarHeader2State();
}

class _CalendarHeader2State extends State<CalendarHeader2> {
  late DateTime _selectedDay;

  @override
  void initState() {
    _selectedDay = widget.initialSelectedDay;
    super.initState();
  }


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
          focusedDay: _selectedDay,
          selectedDayPredicate: (day) {
            return day.isSameDayAs(_selectedDay);
          },
          startingDayOfWeek: StartingDayOfWeek.monday,
          currentDay: DateTime.now(),
          firstDay: DateTime.now().subtract(const Duration(days: 90)),
          lastDay: DateTime.now().add(const Duration(days: 90)),
          onDaySelected: _onDaySelected,
        ),
        const Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Divider(),
        ),
      ],
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
    });
    widget.onDaySelected(_selectedDay);
  }
}

