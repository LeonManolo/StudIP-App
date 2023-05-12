import 'package:animate_do/animate_do.dart';
import 'package:app_ui/app_ui.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/calendar/widgets/calendar_entry_content.dart';

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
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon(
          //   EvaIcons.calendarOutline,
          //   size: MediaQuery.of(context).size.width * 0.2,
          //   weight: 0.1,
          //   fill: 0.1,
          // ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: AppSpacing.lg,
              top: AppSpacing.md,
            ),
            child: Text(
              'Keine Termine',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Text(
            'An diesem Tag hast du keine Termine,\n wähle einen anderen.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).hintColor
            ),
          )
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: ListView.separated(
        itemCount: scheduleData.length,
        separatorBuilder: (_, __) {
          return const Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.lg),
          );
        },
        itemBuilder: (context, index) {
          return SlideInLeft(
            from: MediaQuery.of(context).size.width,
            delay: Duration(milliseconds: 300 + (index * 200)),
            child: CalendarEntryContent(
              timeframe: scheduleData[index].timeframe,
              calendarEntryData: scheduleData[index],
            ),
          );
        },
      ),
    );
  }
}
