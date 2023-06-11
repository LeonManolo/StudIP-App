import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/courses/details/view/widgets/course_page_view_tab_item.dart';

class CoursePageViewHeader extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        controller: controller,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        separatorBuilder: (context, index) => const SizedBox(
          width: AppSpacing.md,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: tabItems.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => onTabChanged?.call(index),
          child: tabItems[index],
        ),
      ),
    );
  }
}
