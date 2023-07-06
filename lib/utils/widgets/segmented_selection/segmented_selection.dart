import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/utils/widgets/segmented_selection/segmented_option.dart';

class SegmentedSelection<T> extends StatefulWidget {
  const SegmentedSelection({
    super.key,
    required this.selected,
    required this.selections,
    this.onSelectionChange,
  });

  final T selected;
  final List<SegmentedSelectionData<T>> selections;
  final ValueChanged<T>? onSelectionChange;

  @override
  State<SegmentedSelection<T>> createState() => _SegmentedSelectionState();
}

class _SegmentedSelectionState<T> extends State<SegmentedSelection<T>> {
  late T _selected;

  @override
  void initState() {
    _selected = widget.selected;
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
                if (i > 0) const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: SegmentedOption(
                    iconData: widget.selections[i].iconData,
                    text: widget.selections[i].text,
                    selected: widget.selections[i].value == _selected,
                    onTap: () {
                      setState(() {
                        _selected = widget.selections[i].value;
                        widget.onSelectionChange
                            ?.call(widget.selections[i].value);
                      });
                    },
                  ),
                ),
                if (i < widget.selections.length - 1)
                  const SizedBox(width: AppSpacing.sm),
              ],
            ),
          ),
      ],
    );
  }
}

class SegmentedSelectionData<T> {
  SegmentedSelectionData({
    required this.iconData,
    required this.text,
    required this.value,
  });

  final IconData iconData;
  final String text;
  final T value;
}
