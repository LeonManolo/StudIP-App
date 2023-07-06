import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/courses/details/info/models/models.dart';

class EventsSection extends ExpansionTile {
  EventsSection({
    super.key,
    required CourseEventExpansionModel eventExpansionModel,
    required void Function({required bool isExpanded}) onExpansionChanged,
  }) : super(
          title: const Text('Termine'),
          children: [
            for (StudIPCourseEventItem event in eventExpansionModel.events)
              ListTile(
                title: Text(event.getEventTimeSpan),
                subtitle: Text(
                  event.categories.isEmpty
                      ? 'Fällt aus'
                      : ('${event.categories.join(', ')} ${_locationString(location: event.location)}'),
                ),
              )
          ],
          initiallyExpanded: eventExpansionModel.isExpanded,
          onExpansionChanged: (isExpanded) =>
              onExpansionChanged(isExpanded: isExpanded),
        );

  static String _locationString({required String? location}) {
    if (location != null) return '- $location';
    return '';
  }
}
