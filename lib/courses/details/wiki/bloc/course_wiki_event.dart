part of 'course_wiki_bloc.dart';

abstract class CourseWikiEvent extends Equatable {
  const CourseWikiEvent();

  @override
  List<Object> get props => [];
}

class CourseWikiReloadRequested extends CourseWikiEvent {}

class CourseWikiReachedBottom extends CourseWikiEvent {}
