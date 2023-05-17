part of 'course_news_bloc.dart';

abstract class CourseNewsEvent extends Equatable {
  const CourseNewsEvent();

  @override
  List<Object> get props => [];
}

class CourseNewsReloadRequested extends CourseNewsEvent {}

class CourseNewsReachedBottom extends CourseNewsEvent {}
