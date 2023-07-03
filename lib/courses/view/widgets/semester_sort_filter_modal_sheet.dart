import 'package:app_ui/app_ui.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/courses/bloc/courses_state.dart';
import 'package:studipadawan/utils/utils.dart';
import 'package:studipadawan/utils/widgets/segmented_selection.dart';

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
          selections: [
            SegmentedSelectionData(
              iconData: EvaIcons.gridOutline,
              text: 'Alle Semester',
            ),
            SegmentedSelectionData(
              iconData: EvaIcons.squareOutline,
              text: 'Aktuelles Semester',
            ),
          ],
          onSelectionChange: (index) {
            final filter = index == 0 ? SemesterFilter.all : SemesterFilter
                .current;
            setState(() {
              currentSemesterFilter = filter;
            });
            onSemesterFilterSelectionChanged(filter);
          },
        ),
        const SizedBox(height: AppSpacing.xlg),
        const ModalBottomSheetSubtitle(title: 'Sortierung'),
        SegmentedSelection(
          selections: [
            SegmentedSelectionData(
              iconData: EvaIcons.arrowCircleUpOutline,
              text: 'Aufsteigend',
            ),
            SegmentedSelectionData(
              iconData: EvaIcons.arrowCircleDownOutline,
              text: 'Absteigen',
            ),
          ],
          onSelectionChange: (index) {
            final sortDirection = index == 0 ? SemesterSortOrder.asc : SemesterSortOrder.desc;
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
