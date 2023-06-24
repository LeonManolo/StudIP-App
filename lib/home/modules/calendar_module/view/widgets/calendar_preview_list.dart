import 'package:flutter/material.dart';
import 'package:studipadawan/home/modules/calendar_module/bloc/calendar_module_bloc.dart';
import 'package:studipadawan/home/modules/calendar_module/model/calendar_entry_preview.dart';
import 'package:studipadawan/home/modules/calendar_module/view/widgets/calendar_preview_tile.dart';
import 'package:studipadawan/utils/empty_view.dart';

class CalendarPreviewList extends StatelessWidget {
  const CalendarPreviewList({
    super.key,
    required this.calendarEntries,
    required this.calendarModuleBloc,
  });
  final List<CalendarEntryPreview> calendarEntries;
  final CalendarModuleBloc calendarModuleBloc;

  @override
  Widget build(BuildContext context) {
    if (calendarEntries.isEmpty) {
      return const Center(
        child: EmptyView(
          title: 'Keine Termine',
          message: 'Es sind keine Termine vorhanden',
        ),
      );
    }
    return SingleChildScrollView(
      child: Column(
        children: calendarEntries.asMap().entries.map((entry) {
          final index = entry.key;
          final calendarEntry = entry.value;
          final isLastEntry = index == calendarEntries.length - 1;

          return Column(
            children: [
              CalendarPreviewTile(
                calendarEntry: calendarEntry,
              ),
              if (!isLastEntry) const Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }
}
