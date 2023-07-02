import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/courses/bloc/courses_state.dart';
import 'package:studipadawan/utils/utils.dart';

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
        SegmentedButton(
          style: segmentedButtonStyle(context: context),
          segments: const [
            ButtonSegment(
              value: SemesterFilter.all,
              label: Text('Alle Semester'),
            ),
            ButtonSegment(
              value: SemesterFilter.current,
              label: Text('Aktuelles Semester'),
            ),
          ],
          selected: {currentSemesterFilter},
          onSelectionChanged: (selectedFilters) {
            {
              setState(
                () => currentSemesterFilter = selectedFilters.first,
              );
              onSemesterFilterSelectionChanged(selectedFilters.first);
            }
          },
        ),
        const SizedBox(height: AppSpacing.xlg),
        const ModalBottomSheetSubtitle(title: 'Sortierung'),
        SegmentedButton(
          style: segmentedButtonStyle(context: context),
          segments: const [
            ButtonSegment(
              value: SemesterSortOrder.asc,
              label: Text('Aufsteigend'),
            ),
            ButtonSegment(
              value: SemesterSortOrder.desc,
              label: Text('Absteigend'),
            ),
          ],
          selected: {currentSemesterSortOrder},
          onSelectionChanged: (selectedSortOrders) {
            setState(
              () => currentSemesterSortOrder = selectedSortOrders.first,
            );
            onSemesterSortOrderSelectionChanged(selectedSortOrders.first);
          },
        )
      ],
    );
  }
}
