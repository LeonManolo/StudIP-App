import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/calendar/calendar_notifications/model/calendar_notifications_course.dart';
import 'package:studipadawan/utils/snackbar.dart';

class CalendarNotificationSaveButton extends StatelessWidget {
  const CalendarNotificationSaveButton({
    super.key,
    required this.onTap,
    required this.totalNotifications,
    required this.courses,
  });

  final VoidCallback onTap;
  final int totalNotifications;
  final List<CalendarNotificationsCourse> courses;

  @override
  Widget build(BuildContext context) {
    final selectedNotifications = _selectedNotificationsCount();
    final maxReached = selectedNotifications > totalNotifications;

    return InkWell(
      onTap: maxReached ? () => _showErrorSnackBar(context) : onTap,
      child: Container(
        color: maxReached ? Colors.red : Theme.of(context).primaryColor,
        alignment: Alignment.center,
        width: double.maxFinite,
        padding: const EdgeInsets.only(
          left: AppSpacing.sm,
          right: AppSpacing.sm,
          top: AppSpacing.xlg,
          bottom: AppSpacing.lg,
        ),
        child: SafeArea(
          child: Text(
            '$selectedNotifications/$totalNotifications Benachrichtigungen speichern',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ),
    );
  }

  int _selectedNotificationsCount() {
    int count = 0;
    for (final course in courses) {
      course.events.forEach((key, courseEvent) {
        if (courseEvent.notificationEnabled) {
          count += 1;
        }
      });
    }
    return count;
  }

  void _showErrorSnackBar(BuildContext context) {
    buildSnackBar(
        context,
        'Du hast das Limit an maximaler Benachrichtigungen überschritten!',
        null,
    );
  }
}
