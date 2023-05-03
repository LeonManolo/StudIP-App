import 'package:app_ui/app_ui.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:flutter/material.dart';


class CalendarCurrentTimeOverlay extends StatelessWidget {
  final Widget child;
  final CalendarTimeframe timeframe;
  final HourMinute currentTime;

  const CalendarCurrentTimeOverlay(
      {Key? key,
        required this.child,
        required this.currentTime,
        required this.timeframe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (timeframe.containsHourMinute(currentTime))
          Positioned.fill(
            child: LayoutBuilder(builder: (context, constraints) {
              const minHeight = 20.0;
              final availableHeight = constraints.maxHeight;
              double heightFactor = timeframe
                  .determinePercentageElapsedByHourMinute(currentTime);

              if (availableHeight * heightFactor < minHeight) {
                heightFactor = minHeight / availableHeight;
              }

              return FractionallySizedBox(
                alignment: Alignment.topCenter,
                heightFactor: heightFactor,
                widthFactor: 1,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      border: const Border(
                        bottom: BorderSide(),
                      )),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg),
                        width: MediaQuery.of(context).size.width * 0.2 - 3,
                        child: Text(
                          "$currentTime",
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                      const CircleAvatar(
                        minRadius: 5,
                        maxRadius: 5,
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.red,
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.red.withOpacity(0.8),
                          height: 1.5,
                          alignment: Alignment.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          )
      ],
    );
  }
}

