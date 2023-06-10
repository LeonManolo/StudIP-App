import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/courses/details/view/widgets/course_page_view_tab_item.dart';

class CoursePageViewHeader extends StatefulWidget {
  const CoursePageViewHeader({
    super.key,
    required this.tabItems,
    this.height = 120,
    this.onTabChanged,
    this.controller,
  });

  final double height;
  final List<CoursePageViewTabItem> tabItems;
  final ValueChanged<int>? onTabChanged;
  final ScrollController? controller;

  @override
  State<CoursePageViewHeader> createState() => _CoursePageViewHeaderState();
}

class _CoursePageViewHeaderState extends State<CoursePageViewHeader> {

  @override
  void initState() {
    print("rebuilding");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: ListView.separated(
        controller: widget.controller,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        separatorBuilder: (context, index) => const SizedBox(
          width: AppSpacing.md,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: widget.tabItems.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => widget.onTabChanged?.call(index),
          child: widget.tabItems[index],
        ),
      ),
    );
  }
}
