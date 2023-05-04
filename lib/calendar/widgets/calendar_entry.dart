import 'package:animate_do/animate_do.dart';
import 'package:app_ui/app_ui.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/calendar/extensions/list_extesions.dart';
import 'package:studipadawan/calendar/widgets/calendar_current_time_overlay.dart';

import 'calendar_entry_divider.dart';

class CalendarEntry extends StatefulWidget {
  final CalendarEntryData? calendarEntryData;
  final bool showDivider;
  final Color color;
  final CalendarTimeframe timeFrame;
  final double opacity;
  final HourMinute currentTime;

  final GlobalKey rowKey;
  final GlobalKey textKey;

  const CalendarEntry(
      {Key? key,
      required this.timeFrame,
      this.showDivider = true,
      this.calendarEntryData,
      required this.color, required this.rowKey, required this.textKey, required this.opacity, required this.currentTime})
      : super(key: key);

  @override
  State<CalendarEntry> createState() => _CalendarEntryState();
}

class _CalendarEntryState extends State<CalendarEntry> {


  @override
  Widget build(BuildContext context) {
    final leftSize = MediaQuery.of(context).size.width * 0.2;

    return CalendarCurrentTimeOverlay(
      rowKey: widget.rowKey,
      timeframe: widget.timeFrame,
      currentTime: widget.currentTime,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                        widget.timeFrame.start.toString(),
                        key: widget.textKey,
                        style: TextStyle(
                            //color: Theme.of(context).disabledColor,
                          color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(
                            widget.opacity, // hier muss geprüft werden ob die widgets overlappen
                          ),
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Opacity(
                  opacity: widget.calendarEntryData == null ? 0 : 1,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        margin: const EdgeInsets.only(right: AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: widget.color.withOpacity(0.15),
                          boxShadow: [
                            BoxShadow(
                              color: widget.color.withOpacity(0.1),
                              blurRadius: 5,
                              spreadRadius: 5,
                              offset: const Offset(2, 4),
                            )
                          ],
                          border: Border(
                              left: BorderSide(
                            width: 3,
                            color: widget.color,
                          ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: AppSpacing.lg),
                              child: Text(
                                widget.calendarEntryData?.title ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            Text(widget.calendarEntryData?.description ?? ""),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: AppSpacing.lg),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Visibility(
                                    visible: widget.calendarEntryData?.locations
                                        .firstOrNull() != null,
                                    child: Row(
                                      children: [
                                        Icon(
                                          EvaIcons.pinOutline,
                                          size: 20,
                                          color: widget.color,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: AppSpacing.xs,
                                              right: AppSpacing.lg),
                                          child: Text(
                                            widget.calendarEntryData?.locations
                                                .firstOrNull() ??
                                                "",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: widget.color,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    EvaIcons.clockOutline,
                                    size: 20,
                                    color: widget.color,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: AppSpacing.xs),
                                    child: Text(
                                      widget.timeFrame.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: widget.color,
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
              ),
            ],
          ),
          if (widget.showDivider) CalendarEntryDivider(paddingLeft: leftSize),
        ],
      ),
    );
  }
}
