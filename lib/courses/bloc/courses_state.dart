import 'package:courses_repository/courses_repository.dart';
import 'package:equatable/equatable.dart';

enum CourseStatus {
  initial,
  loading,
  populated,
  failure,
}

class CourseState extends Equatable {

  const CourseState({
    required this.status,
    this.semesters = const [],
  });

  const CourseState.initial()
      : this(
          status: CourseStatus.initial,
        );
  final CourseStatus status;
  final List<Semester> semesters;

  @override
  List<Object?> get props => [status, semesters];

  CourseState copyWith({CourseStatus? status, List<Semester>? semesters}) {
    return CourseState(
        status: status ?? this.status, semesters: semesters ?? this.semesters,);
  }
}
