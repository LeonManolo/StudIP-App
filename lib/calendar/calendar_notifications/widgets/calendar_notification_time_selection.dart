import 'package:flutter/material.dart';
import 'package:studipadawan/calendar/calendar_notifications/bloc/calendar_notifications_bloc.dart';

class CalendarNotificationTimeSelection extends StatelessWidget {
  const CalendarNotificationTimeSelection({
    required this.onChanged,
    required this.activeNotificationTime,
    super.key,
  });

  final NotificationTime activeNotificationTime;
  final ValueChanged<NotificationTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RadioListTile<NotificationTime>(
          title: const Text('15 Minuten vorher'),
          subtitle:
              const Text('Erhalte Benachrichtigungen 15 Minuten vor Beginn'),
          value: NotificationTime.fifteenMinutesEarly,
          groupValue: activeNotificationTime,
          onChanged: _onChange,
        ),
        RadioListTile(
            title: const Text('30 Minuten vorher'),
            subtitle:
                const Text('Erhalte Benachrichtigungen 30 Minuten vor Beginn'),
            value: NotificationTime.thirtyMinutesEarly,
            groupValue: activeNotificationTime,
            onChanged: _onChange,),
        RadioListTile(
          title: const Text('60 Minuten vorher'),
          subtitle:
              const Text('Erhalte Benachrichtigungen 60 Minuten vor Beginn'),
          value: NotificationTime.sixtyMinutesEarly,
          groupValue: activeNotificationTime,
          onChanged: _onChange,
        ),
      ],
    );
  }

  void _onChange(NotificationTime? time) {
    if (time != null) {
      onChanged(time);
    }
  }
}
