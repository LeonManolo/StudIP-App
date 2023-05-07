import 'package:flutter/material.dart';

import 'package:studipadawan/courses/details/info/models/models.dart';

class GeneralInfoSection extends ExpansionTile {
  GeneralInfoSection({
    super.key,
    required GeneralInfoExpansionModel generalInfo,
    required void Function(bool) onExpansionChanged,
  }) : super(
          title: const Text('Allgemein'),
          children: [
            ListTile(
              title: const Text('Titel'),
              subtitle: Text(generalInfo.courseDetails.title),
            ),
            ListTile(
              title: const Text('Untertitel'),
              subtitle: Text(generalInfo.courseDetails.subtitle ?? 'N/A'),
            ),
            ListTile(
              title: const Text('Kursnummer'),
              subtitle: Text(generalInfo.courseDetails.courseNumber ?? 'N/A'),
            ),
            ListTile(
              title: const Text('Beschreibung'),
              subtitle: Text(generalInfo.courseDetails.description ?? 'N/A'),
            )
          ],
          initiallyExpanded: generalInfo.isExpanded,
          onExpansionChanged: (isExpanded) => onExpansionChanged(isExpanded),
        );
}
