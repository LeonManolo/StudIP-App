import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class CalendarEntryDivider extends StatelessWidget {
  final double paddingLeft;

  const CalendarEntryDivider({Key? key, required this.paddingLeft}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: paddingLeft,
          top: AppSpacing.xlg,
          bottom: AppSpacing.sm,
          right: AppSpacing.sm),
      color: Theme.of(context).dividerColor,
      height: 1,
      width: double.infinity,
    );
  }
}
