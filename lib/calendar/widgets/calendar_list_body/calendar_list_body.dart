import 'package:animate_do/animate_do.dart';
import 'package:app_ui/app_ui.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/calendar/widgets/calendar_entry_content.dart';
import 'package:studipadawan/utils/empty_view.dart';

class CalendarListBody extends StatelessWidget {
  const CalendarListBody({
    super.key,
    required this.scheduleData,
    required this.selectedDay,
  });

  final DateTime selectedDay;
  final List<CalendarEntryData> scheduleData;

  @override
  Widget build(BuildContext context) {
    if (scheduleData.isEmpty) {
      return const EmptyView(
        title: 'Keine Termine',
        message: 'An diesem Tag hast du keine Termine,\n wähle einen Anderen.',
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: scheduleData.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: AppSpacing.lg),
            child: SlideInLeft(
              from: MediaQuery.of(context).size.width,
              delay: Duration(milliseconds: 300 + (index * 200)),
              child: CalendarEntryContent(
                timeframe: scheduleData[index].timeframe,
                calendarEntryData: scheduleData[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
