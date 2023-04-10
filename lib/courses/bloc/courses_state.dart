import 'package:equatable/equatable.dart';
import 'package:courses_repository/src/models/models.dart';

enum CourseStatus {
  initial,
  loading,
  populated,
  failure,
}

class CourseState extends Equatable {
  final CourseStatus status;
  final List<Semester> semesters;

  const CourseState({
    required this.status,
    this.semesters = const [],
  });

  const CourseState.initial()
      : this(
          status: CourseStatus.initial,
        );

  @override
  List<Object?> get props => [status, semesters];

  CourseState copyWith({CourseStatus? status, List<Semester>? semesters}) {
    return CourseState(
        status: status ?? this.status, semesters: semesters ?? this.semesters);
  }
}
