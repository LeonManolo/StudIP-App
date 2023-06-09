import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/courses/details/bloc/course_details_bloc.dart';

class CourseDetailTabView extends StatelessWidget {
  const CourseDetailTabView({
    super.key,
    required this.tab,
    required this.isSelected,
    required this.onSelection,
  });

  final CourseDetailsTab tab;
  final bool isSelected;
  final void Function() onSelection;

  @override
  Widget build(BuildContext context) {
    final bgColor =  Theme.of(context).hintColor.withOpacity(0.04);
    return GestureDetector(
      onTap: onSelection,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).scaffoldBackgroundColor, width: 2),
          color: isSelected ? null  : bgColor,
        ),
        width: 105,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Icon(
                tab.icon,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
              decoration: BoxDecoration(
                  color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.08) : Theme.of(context).scaffoldBackgroundColor ,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
            ),
            Text(
              tab.title,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}
