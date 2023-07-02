import 'package:animate_do/animate_do.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/calendar/bloc/calendar_state.dart';

class SelectedLayoutIndicator extends StatelessWidget {
  const SelectedLayoutIndicator({
    super.key,
    required this.calendarBodyType,
    required this.animate,
    this.duration = const Duration(milliseconds: 800),
  });

  final CalendarBodyType calendarBodyType;
  final bool animate;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: calendarBodyType == CalendarBodyType.list ? 0 : 1,
      duration: duration,
      child: Icon(
        EvaIcons.repeat,
        color: calendarBodyType == CalendarBodyType.list
            ? null
            : Theme.of(context).primaryColor,
      ),
    );
  }
}
