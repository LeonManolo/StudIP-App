import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';
import '../../models/models.dart';

class EventsSection extends ExpansionTile {
  EventsSection(
      {Key? key,
      required CourseEventExpansionModel eventExpansionModel,
      required Function(bool) onExpansionChanged})
      : super(
          key: key,
          title: const Text("Termine"),
          children: [
            for (StudIPCourseEvent event in eventExpansionModel.events)
              ListTile(
                title: Text(event.getEventTimeSpan),
                subtitle: Text(event.categories.isEmpty
                    ? "Fällt aus"
                    : event.categories.join(",")),
              )
          ],
          initiallyExpanded: eventExpansionModel.isExpanded,
          onExpansionChanged: (isExpanded) => onExpansionChanged(isExpanded),
        );
}
