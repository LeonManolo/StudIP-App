import 'package:calender_repository/calender_repository.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/calendar/widgets/calendar_course_presentation/calendar_course_page.dart';

void handleCalendarEntrySelection({
  required BuildContext context,
  required CalendarEntryData? calendarEntryData,
}) {
  if (calendarEntryData?.courseId != null) {
    Navigator.of(context).push(
      MaterialPageRoute<CalendarCoursePage>(
        builder: (context) =>
            CalendarCoursePage(courseId: calendarEntryData!.courseId!),
      ),
    );
  } else {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(calendarEntryData?.title ?? 'Termin ohne Titel'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(
                'Beschreibung: ${calendarEntryData?.description ?? 'N/A'}',
              ),
              const SizedBox(height: 12),
              Text(
                'Uhrzeit: ${calendarEntryData?.timeframe}',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ok'),
          )
        ],
      ),
    );
  }
}
