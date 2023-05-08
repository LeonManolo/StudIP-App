import 'package:app_ui/app_ui.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class CalendarHeader extends StatelessWidget {

  const CalendarHeader({super.key, required this.dateTime, required this.onPreviousButtonPress, required this.onNextButtonPress, required this.onDatePress});
  final DateTime dateTime;
  final VoidCallback onPreviousButtonPress;
  final VoidCallback onNextButtonPress;
  final VoidCallback onDatePress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onPreviousButtonPress,
            icon: const Icon(EvaIcons.arrowIosBackOutline),
            color: Theme.of(context).hintColor,
          ),
          InkWell(
            onTap: onDatePress,
            child: Text(
              '${weekday(dateTime.weekday)}, ${dateTime.day}.${dateTime.month}.${dateTime.year}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          IconButton(
            onPressed: onNextButtonPress,
            icon: const Icon(EvaIcons.arrowIosForwardOutline),
            color: Theme.of(context).hintColor,
          ),
        ],
      ),
    );
  }

  // TODO: vielleicht als extension von DateTime
  String weekday(int index) {
    switch (index) {
      case 1:
        {
          return 'Montag';
        }
      case 2:
        {
          return 'Dienstag';
        }
      case 3:
        {
          return 'Mittwoch';
        }
      case 4:
        {
          return 'Donnerstag';
        }
      case 5:
        {
          return 'Freitag';
        }
      case 6:
        {
          return 'Samstag';
        }
      case 7:
        {
          return 'Sonntag';
        }
      default:
        {
          return '';
        }
    }
  }
}
