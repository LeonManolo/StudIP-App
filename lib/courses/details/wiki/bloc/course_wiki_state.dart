part of 'course_wiki_bloc.dart';

abstract class CourseWikiState extends Equatable {
  const CourseWikiState();
  
  @override
  List<Object> get props => [];
}

class CourseWikiInitial extends CourseWikiState {}
