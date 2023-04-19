part of 'course_forum_bloc.dart';

abstract class CourseForumState extends Equatable {
  const CourseForumState();
  
  @override
  List<Object> get props => [];
}

class CourseForumInitial extends CourseForumState {}
