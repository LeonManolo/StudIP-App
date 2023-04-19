part of 'course_info_bloc.dart';

abstract class CourseInfoState extends Equatable {
  const CourseInfoState();
  
  @override
  List<Object> get props => [];
}

class CourseInfoInitial extends CourseInfoState {}
