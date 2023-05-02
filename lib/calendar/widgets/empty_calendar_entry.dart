import 'package:app_ui/app_ui.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import 'calendar_entry_divider.dart';

class EmptyCalendarEntry extends StatelessWidget {
  final CalendarTimeframe timeFrame;
  final bool showDivider;

  const EmptyCalendarEntry(
      {Key? key, required this.timeFrame, required this.showDivider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final leftSize = MediaQuery.of(context).size.width * 0.2;
    final testHourMinute = HourMinute(hours: 9, minutes: 44);

    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //if (showDivider) CalendarEntryDivider(paddingLeft: leftSize),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: leftSize,
                    maxHeight: double.infinity,
                    minHeight: 0,
                    maxWidth: leftSize,
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          timeFrame.start.toString(),
                          style: const TextStyle(
                              //color: Theme.of(context).disabledColor,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        margin: const EdgeInsets.only(right: AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: AppSpacing.lg),
                              child: Text(
                                "",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            const Text(""),
                            Opacity(
                              opacity: 0,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: AppSpacing.lg),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      EvaIcons.pinOutline,
                                      size: 20,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          left: AppSpacing.xs,
                                          right: AppSpacing.lg),
                                      child: Text(
                                        "",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      EvaIcons.clockOutline,
                                      size: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: AppSpacing.xs),
                                      child: Text(
                                        timeFrame.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        if(timeFrame.containsHourMinute(testHourMinute))
        Positioned.fill(
          child: FractionallySizedBox(
            alignment: Alignment.topCenter,
            heightFactor: timeFrame.determinePercentageElapsedByHourMinute(testHourMinute),
            widthFactor: 1,
            child: Container(decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(),
              )
            ),),
          ),
        )
      ],
    );
  }
}
