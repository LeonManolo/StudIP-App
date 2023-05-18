import 'package:courses_repository/courses_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:studipadawan/courses/models/course_list_item.dart';

enum SemesterFilter { current, all }

enum SemesterSortOrder { asc, desc }

sealed class CoursesState extends Equatable {
  const CoursesState({
    required this.semesterFilter,
    required this.semesterSortOrder,
  });

  final SemesterFilter semesterFilter;
  final SemesterSortOrder semesterSortOrder;

  @override
  List<Object?> get props => [semesterFilter, semesterSortOrder];
}

class CoursesStateLoading extends CoursesState {
  const CoursesStateLoading({
    required super.semesterFilter,
    required super.semesterSortOrder,
  });
}

class CoursesStateDidLoad extends CoursesState {
  const CoursesStateDidLoad({
    required super.semesterFilter,
    required super.semesterSortOrder,
    required this.semesters,
  });

  final List<Semester> semesters;

  List<CourseListItem> get items {
    final List<CourseListItem> newItems = [];

    for (var semesterIndex = 0;
        semesterIndex < semesters.length;
        semesterIndex++) {
      final Semester semester = semesters.elementAt(semesterIndex);
      newItems.add(CourseListSemesterItem(semester: semester));

      for (var courseIndex = 0;
          courseIndex < semester.courses.length;
          courseIndex++) {
        newItems.add(
          CourseListCourseItem(
            course: semester.courses.elementAt(courseIndex),
          ),
        );
      }
    }

    return newItems;
  }

  @override
  List<Object?> get props => [semesters, semesterFilter, semesterSortOrder];

  CoursesStateDidLoad copyWith({
    List<Semester>? semesters,
    SemesterFilter? semesterFilter,
    SemesterSortOrder? semesterSortOrder,
  }) {
    return CoursesStateDidLoad(
      semesterFilter: semesterFilter ?? this.semesterFilter,
      semesterSortOrder: semesterSortOrder ?? this.semesterSortOrder,
      semesters: semesters ?? this.semesters,
    );
  }
}

class CoursesStateError extends CoursesState {
  const CoursesStateError({
    required super.semesterFilter,
    required super.semesterSortOrder,
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  List<Object?> get props => [semesterFilter, semesterSortOrder, errorMessage];
}
