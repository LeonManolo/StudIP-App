import 'package:animate_do/animate_do.dart';
import 'package:app_ui/app_ui.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/calendar/widgets/calendar_entry_content.dart';

class Calendar2 extends StatelessWidget {
  const Calendar2({
    super.key,
    required this.scheduleData,
    required this.selectedDay,
  });

  final DateTime selectedDay;
  final Map<Weekdays, List<CalendarEntryData>> scheduleData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: ListView.separated(
        itemCount:
            scheduleData[Weekdays.indexToWeekday(selectedDay.weekday - 1)]
                    ?.length ??
                0,
        separatorBuilder: (_, __) {
          return const Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.lg),
          );
        },
        itemBuilder: (context, index) {
          final calendarData =
              scheduleData[Weekdays.indexToWeekday(selectedDay.weekday - 1)]
                  ?[index];

          if (calendarData != null) {
            return SlideInLeft(
              from: MediaQuery.of(context).size.width,
              delay: Duration(milliseconds: 300 + (index * 200)),
              child: CalendarEntryContent(
                timeframe: calendarData.timeframe,
                calendarEntryData: calendarData,
              ),
            );
          } else {
            return null;
          }
        },
      ),
    );
  }
}
