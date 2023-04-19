part of 'course_files_bloc.dart';

abstract class CourseFilesState extends Equatable {
  const CourseFilesState();
  
  @override
  List<Object> get props => [];
}

class CourseFilesInitial extends CourseFilesState {}
