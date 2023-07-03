import 'package:flutter/material.dart';
import 'package:studipadawan/calendar/utils/handle_calendar_entry_selection.dart';
import 'package:studipadawan/home/modules/calendar_module/model/calendar_preview_model.dart';

class CalendarPreviewTile extends StatelessWidget {
  const CalendarPreviewTile({super.key, required this.calendarEntry});
  final CalendarPreviewModel calendarEntry;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(calendarEntry.title),
      subtitle: Text(calendarEntry.subtitle),
      leading: Icon(calendarEntry.iconData),
      onTap: () {
        handleCalendarEntrySelection(
          context: context,
          calendarEntryData: calendarEntry.calendarEntryData,
        );
      },
    );
  }
}
