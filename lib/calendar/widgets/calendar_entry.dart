import 'dart:ffi';

import 'package:app_ui/app_ui.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import 'calendar_entry_divider.dart';

class CalendarEntry extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final bool showDivider;
  final String location;
  final CalendarTimeframe timeFrame;

  const CalendarEntry(
      {Key? key,
      required this.title,
      required this.color,
      required this.subtitle,
      required this.location,
      required this.timeFrame,
      this.showDivider = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final leftSize = MediaQuery.of(context).size.width * 0.2;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showDivider) CalendarEntryDivider(paddingLeft: leftSize),
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
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.1),
                          blurRadius: 5,
                          spreadRadius: 5,
                          offset: const Offset(2, 4),
                        )
                      ],
                      border: Border(
                          left: BorderSide(
                        width: 3,
                        color: color,
                      )),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                          child: Text(
                            title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Text(subtitle),
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.lg),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                EvaIcons.pinOutline,
                                size: 20,
                                color: color,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: AppSpacing.xs, right: AppSpacing.lg),
                                child: Text(
                                  location,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: color,
                                  ),
                                ),
                              ),
                              Icon(
                                EvaIcons.clockOutline,
                                size: 20,
                                color: color,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: AppSpacing.xs),
                                child: Text(
                                  timeFrame.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: color,
                                  ),
                                ),
                              )
                            ],
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
    );
  }
}


