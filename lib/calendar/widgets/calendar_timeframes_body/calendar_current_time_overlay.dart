import 'package:animate_do/animate_do.dart';
import 'package:app_ui/app_ui.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:flutter/material.dart';

class CalendarCurrentTimeOverlay extends StatelessWidget {

  const CalendarCurrentTimeOverlay({
    super.key,
    required this.child,
    required this.currentTime,
    required this.timeframe,
    required this.rowKey,
    this.excludingEqualTimes = false,
  });
  final Widget child;
  final CalendarTimeframe timeframe;
  final HourMinute currentTime;
  final bool excludingEqualTimes;

  final GlobalKey rowKey;

  @override
  Widget build(BuildContext context) {
    final timeframeContainsCurrentTime = excludingEqualTimes
        ? timeframe.containsHourMinuteExclusive(currentTime)
        : timeframe.containsHourMinute(currentTime);

    final primaryColor = context.adaptivePrimaryColor;

    return Stack(
      children: [
        child,
        if (timeframeContainsCurrentTime)
          Positioned.fill(
            child: LayoutBuilder(builder: (context, constraints) {
              const minHeight = 20.0;
              final availableHeight = constraints.maxHeight;
              double heightFactor =
                  timeframe.determinePercentageElapsedByHourMinute(currentTime);

              if (availableHeight * heightFactor < minHeight) {
                heightFactor = minHeight / availableHeight;
              }

              return FractionallySizedBox(
                alignment: Alignment.topCenter,
                heightFactor: heightFactor,
                widthFactor: 1,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: FadeIn(
                    child: Row(
                      key: rowKey,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,),
                          width: MediaQuery.of(context).size.width * 0.2 - 3,
                          child: Text(
                            '$currentTime',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          minRadius: 5,
                          maxRadius: 5,
                          backgroundColor: primaryColor,
                          child: const CircleAvatar(
                            radius: 2.5,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: primaryColor,
                            height: 2,
                            alignment: Alignment.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },),
          )
      ],
    );
  }
}
