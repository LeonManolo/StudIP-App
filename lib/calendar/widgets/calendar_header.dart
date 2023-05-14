import 'package:app_ui/app_ui.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarHeader extends StatefulWidget {
  const CalendarHeader({super.key, required this.onDaySelected, required this.initialSelectedDay});

  final void Function(DateTime selectedDay) onDaySelected;
  final DateTime initialSelectedDay;


  @override
  State<CalendarHeader> createState() => _CalendarHeaderState();
}

class _CalendarHeaderState extends State<CalendarHeader> {
  late DateTime _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;

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
          locale: 'DE_de',
          calendarFormat: _calendarFormat,
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
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

