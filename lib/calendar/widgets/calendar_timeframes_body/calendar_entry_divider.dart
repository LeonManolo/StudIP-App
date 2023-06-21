import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class CalendarEntryDivider extends StatelessWidget {

  const CalendarEntryDivider({super.key, required this.paddingLeft});
  final double paddingLeft;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: paddingLeft,
          top: AppSpacing.xlg,
          bottom: AppSpacing.sm,
      ),
      color: context.adaptiveHintColor,
      height: 1,
      width: double.infinity,
    );
  }
}
