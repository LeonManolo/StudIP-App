import 'package:equatable/equatable.dart';
import 'package:studip_api_client/studip_api_client.dart';

enum CourseStatus {
  initial,
  loading,
  populated,
  failure,
}

class CourseState extends Equatable {
  final CourseStatus status;
  final List<Course> courses;

  const CourseState({
    required this.status,
    this.courses = const [],
  });

  const CourseState.initial()
      : this(
          status: CourseStatus.initial,
        );

  @override
  List<Object?> get props => [status, courses];

  CourseState copyWith({CourseStatus? status, List<Course>? courses}) {
    return CourseState(
        status: status ?? this.status, courses: courses ?? this.courses);
  }
}
