import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class CoursePageViewTabItem extends StatelessWidget {
  const CoursePageViewTabItem({
    super.key,
    required this.icon,
    required this.active,
    required this.title,
  });

  final IconData icon;
  final bool active;
  final String title;

  double get width => 105;

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).hintColor.withOpacity(0.04);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: active
              ? Theme.of(context).primaryColor
              : Theme.of(context).scaffoldBackgroundColor,
          width: 2,
        ),
        color: active ? null : bgColor,
      ),
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
                color: active
                    ? Theme.of(context).primaryColor.withOpacity(0.08)
                    : Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 30,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
