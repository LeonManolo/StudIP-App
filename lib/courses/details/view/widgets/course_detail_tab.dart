import 'package:flutter/material.dart';
import 'package:studipadawan/courses/details/bloc/course_details_bloc.dart';

class CourseDetailTabView extends StatelessWidget {
  final CourseDetailsTab tab;
  final bool isSelected;
  final Function onSelection;

  const CourseDetailTabView({
    Key? key,
    required this.tab,
    required this.isSelected,
    required this.onSelection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelection(),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isSelected ? Colors.orange : Colors.black12),
        width: 100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(tab.icon), Text(tab.title)],
          ),
        ),
      ),
    );
  }
}
