import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/utils/widgets/segmented_option.dart';

class SegmentedSelection extends StatefulWidget {
  const SegmentedSelection({
    super.key,
    this.initialSelection = 0,
    required this.selections,
    this.onSelectionChange,
  });

  final int initialSelection;
  final List<SegmentedSelectionData> selections;
  final ValueChanged<int>? onSelectionChange;

  @override
  State<SegmentedSelection> createState() => _SegmentedSelectionState();
}

class _SegmentedSelectionState extends State<SegmentedSelection> {
  int _selectedIndex = 0;

  @override
  void initState() {
    _selectedIndex = widget.initialSelection;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < widget.selections.length; i++)
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: SegmentedOption(
                    iconData: widget.selections[i].iconData,
                    text: widget.selections[i].text,
                    selected: i == _selectedIndex,
                    onTap: () {
                      setState(() {
                        _selectedIndex = i;
                        widget.onSelectionChange?.call(i);
                      });
                    },
                  ),
                ),
                if (i < widget.selections.length - 1)
                  const SizedBox(width: AppSpacing.lg),
              ],
            ),
          ),
      ],
    );
  }
}

class SegmentedSelectionData {
  SegmentedSelectionData({
    required this.iconData,
    required this.text,
  });

  final IconData iconData;
  final String text;
}
