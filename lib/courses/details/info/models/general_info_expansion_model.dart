import 'package:courses_repository/courses_repository.dart';

class GeneralInfoExpansionModel {
  final CourseDetails courseDetails;
  bool isExpanded;

  GeneralInfoExpansionModel({
    required this.courseDetails,
    this.isExpanded = false,
  });

  GeneralInfoExpansionModel copyWith(
      {CourseDetails? courseDetails, bool? isExpanded}) {
    return GeneralInfoExpansionModel(
        courseDetails: courseDetails ?? this.courseDetails,
        isExpanded: isExpanded ?? this.isExpanded);
  }
}
