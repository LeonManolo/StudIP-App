import 'package:courses_repository/src/models/models.dart' as RepositoryModels;

class Course {
  final String id;
  final String title;
  final String? subtitle;
  final String semesterId;
  final Function onCourseSelection;

  Course({
    required RepositoryModels.Course repositoryCourse,
    required this.onCourseSelection,
  })  : id = repositoryCourse.id,
        title = repositoryCourse.title,
        subtitle = repositoryCourse.subtitle,
        semesterId = repositoryCourse.semesterId;
}
