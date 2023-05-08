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
    return GestureDetector(
      onTap: onSelection,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected ? Theme.of(context).primaryColor : Colors.black12,
        ),
        width: 100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                tab.icon,
                color: isSelected ? Colors.white : Colors.black,
              ),
              Text(
                tab.title,
                style:
                    TextStyle(color: isSelected ? Colors.white : Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }
}
