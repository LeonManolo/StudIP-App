import 'package:app_ui/app_ui.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/calendar/extensions/list_extesions.dart';
import 'package:studipadawan/calendar/widgets/calendar_entry.dart';
import 'package:studipadawan/calendar/widgets/calendar_header.dart';
import 'package:studipadawan/calendar/widgets/empty_calendar_entry.dart';


//TODO: automatic scroll to current time
class Calendar extends StatefulWidget {
  final DateTime date;
  final List<CalendarTimeframe> scheduleStructure;
  final Map<Weekdays, Map<String, CalendarEntryData>> scheduleData;
  final VoidCallback onPreviousButtonPress;
  final VoidCallback onNextButtonPress;

  const Calendar(
      {Key? key,
      required this.scheduleStructure,
      required this.scheduleData,
      required this.date,
        required this.onPreviousButtonPress,
        required this.onNextButtonPress})
      : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final ScrollController _controller = ScrollController();
  late final itemKeys =
      List.generate(widget.scheduleStructure.length, (index) => GlobalObjectKey(index));
      //List.filled(widget.scheduleStructure.length, GlobalObjectKey());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      int index = widget.scheduleStructure.indexWhere((element) {
        final currentDate = DateTime.now();
        final currentTime =
        HourMinute(hours: currentDate.hour, minutes: currentDate.minute);
        return element.isInBetween(currentTime);
      });
      if (index != -1) {
        print("index is not -1");
        final renderObject = itemKeys[index].currentContext?.findRenderObject();
        print(renderObject);
        if (renderObject != null) {
          print("Should scroll");
          _controller.position.ensureVisible(
            renderObject,
            alignment: 0.5,
            // How far into view the item should be scrolled (between 0 and 1).
            duration: const Duration(seconds: 1),
          );
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final weekday = Weekdays.indexToWeekday(widget.date.weekday - 1);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CalendarHeader(
          dateTime: widget.date,
          onPreviousButtonPress: widget.onPreviousButtonPress,
          onNextButtonPress: widget.onNextButtonPress,
        ),
        Expanded(
          child: Stack(
            children: [
              ListView.builder(
                  controller: _controller,
                  itemCount: widget.scheduleStructure.length,
                  itemBuilder: (context, index) {
                    final key = widget.scheduleStructure[index].combinedKey();
                    final entry = widget.scheduleData[weekday]?[key];

                    if (entry == null) {
                      return EmptyCalendarEntry(
                        key: itemKeys[index],
                        timeFrame: widget.scheduleStructure[index],
                        showDivider:
                            index != (widget.scheduleStructure.length - 1),
                      );
                    } else {
                      return CalendarEntry(
                        key: itemKeys[index],
                        showDivider:
                            index != (widget.scheduleStructure.length - 1),
                        color: Colors.green,
                        title: widget.scheduleData[weekday]?[key]?.title ?? "",
                        subtitle: widget.scheduleData[weekday]?[key]?.description ?? "",
                        location: widget.scheduleData[weekday]?[key]?.locations.firstOrNull() ?? "",
                        timeFrame: widget.scheduleStructure[index],
                      );
                    }
                  }),
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Row(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      width: MediaQuery.of(context).size.width * 0.2 - 3,
                      child: const Text(
                        "8:00",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const CircleAvatar(
                      radius: 5,
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
              )
            ],
          ),
        )
      ],
    );
  }
}
