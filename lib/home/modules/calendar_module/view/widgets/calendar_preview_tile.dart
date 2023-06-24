import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/calendar/view/calendar_detail_page.dart';
import 'package:studipadawan/home/modules/calendar_module/model/calendar_entry_preview.dart';

class CalendarPreviewTile extends StatelessWidget {
  const CalendarPreviewTile({super.key, required this.calendarEntry});
  final CalendarEntryPreview calendarEntry;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(calendarEntry.title ?? 'Kein Titel'),
      subtitle: Text(
        'In ${calendarEntry.getTimeString()}'
        '\n${calendarEntry.getDay()}, ${calendarEntry.getFormattedDate()}'
        '${calendarEntry.locations.isNotEmpty ? '\nOrt: ${calendarEntry.locations.join(', ')}' : ''}'
    
      ),
      leading: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Icon(EvaIcons.calendar)],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<CalendarDetailPage>(
            builder: (context) {
              return const CalendarDetailPage();
            },
          ),
        );
      },
    );
  }
}
