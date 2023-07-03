import 'package:app_ui/app_ui.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/courses/bloc/courses_state.dart';
import 'package:studipadawan/utils/utils.dart';
import 'package:studipadawan/utils/widgets/segmented_selection/segmented_selection.dart';

class SemesterSortFilterModalSheet extends StatefulWidget {
  const SemesterSortFilterModalSheet({
    super.key,
    required this.onSemesterFilterSelectionChanged,
    required this.onSemesterSortOrderSelectionChanged,
    required this.currentSemesterFilter,
    required this.currentSemesterSortOrder,
  });

  final void Function(SemesterFilter) onSemesterFilterSelectionChanged;
  final void Function(SemesterSortOrder) onSemesterSortOrderSelectionChanged;
  final SemesterFilter currentSemesterFilter;
  final SemesterSortOrder currentSemesterSortOrder;

  @override
  // ignore: library_private_types_in_public_api
  _SemesterSortFilterModalSheetState createState() =>
      _SemesterSortFilterModalSheetState();
}

class _SemesterSortFilterModalSheetState
    extends State<SemesterSortFilterModalSheet> {
  late void Function(SemesterFilter) onSemesterFilterSelectionChanged;
  late void Function(SemesterSortOrder) onSemesterSortOrderSelectionChanged;
  late SemesterFilter currentSemesterFilter;
  late SemesterSortOrder currentSemesterSortOrder;

  @override
  void initState() {
    onSemesterFilterSelectionChanged = widget.onSemesterFilterSelectionChanged;
    onSemesterSortOrderSelectionChanged =
        widget.onSemesterSortOrderSelectionChanged;
    currentSemesterFilter = widget.currentSemesterFilter;
    currentSemesterSortOrder = widget.currentSemesterSortOrder;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ModalBottomSheetSubtitle(title: 'Semester'),
        SegmentedSelection(
          selected: currentSemesterFilter,
          selections: [
            SegmentedSelectionData(
              value: SemesterFilter.all,
              iconData: EvaIcons.gridOutline,
              text: 'Alle Semester',
            ),
            SegmentedSelectionData(
              value: SemesterFilter.current,
              iconData: EvaIcons.squareOutline,
              text: 'Aktuelles Semester',
            ),
          ],
          onSelectionChange: (filter) {
            setState(() {
              currentSemesterFilter = filter;
            });
            onSemesterFilterSelectionChanged(filter);
          },
        ),
        const SizedBox(height: AppSpacing.xlg),
        const ModalBottomSheetSubtitle(title: 'Sortierung'),
        SegmentedSelection(
          selected: currentSemesterSortOrder,
          selections: [
            SegmentedSelectionData(
              value: SemesterSortOrder.desc,
              iconData: EvaIcons.arrowCircleDownOutline,
              text: 'Absteigend',
            ),
            SegmentedSelectionData(
              value: SemesterSortOrder.asc,
              iconData: EvaIcons.arrowCircleUpOutline,
              text: 'Aufsteigend',
            ),
          ],
          onSelectionChange: (sortDirection) {
            setState(() {
              currentSemesterSortOrder = sortDirection;
            });
            onSemesterSortOrderSelectionChanged(sortDirection);
          },
        ),
      ],
    );
  }
}
