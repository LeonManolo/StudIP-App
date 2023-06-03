import 'package:app_ui/app_ui.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/calendar/extensions/list_extensions.dart';

/// Right side of the Calendar entry, shows the calendar data
class CalendarEntryContent extends StatelessWidget {
  const CalendarEntryContent({
    super.key,
    this.calendarEntryData,
    this.backgroundColor,
    this.padding = 0,
    required this.timeframe,
  });

  final CalendarEntryData? calendarEntryData;
  final Color? backgroundColor;
  final double padding;
  final CalendarTimeframe timeframe;

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? context.adaptivePrimaryColor;
    return Opacity(
      opacity: calendarEntryData == null ? 0 : 1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => _navigateToCalendarDetailPage(context),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              margin: EdgeInsets.only(right: padding),
              decoration: BoxDecoration(
                color: bgColor.withOpacity(0.15),
                boxShadow: [
                  BoxShadow(
                    color: bgColor.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 5,
                    offset: const Offset(2, 4),
                  )
                ],
                border: Border(
                  left: BorderSide(
                    width: 3,
                    color: bgColor,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppSpacing.lg,
                    ),
                    child: Text(
                      calendarEntryData?.title ?? '',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  if (calendarEntryData?.description != null)
                    Text(calendarEntryData!.description!),
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.lg),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                          visible:
                              calendarEntryData?.locations.firstOrNull() != null,
                          child: Row(
                            children: [
                              Icon(
                                EvaIcons.pinOutline,
                                size: 20,
                                color: bgColor,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: AppSpacing.xs,
                                  right: AppSpacing.lg,
                                ),
                                child: Text(
                                  calendarEntryData?.locations.firstOrNull() ??
                                      '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: bgColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          EvaIcons.clockOutline,
                          size: 20,
                          color: bgColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: AppSpacing.xs,
                          ),
                          child: Text(
                            timeframe.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: bgColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _navigateToCalendarDetailPage(BuildContext context) {
    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CalendarDetailPage()));
  }
}
