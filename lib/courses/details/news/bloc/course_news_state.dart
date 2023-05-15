part of 'course_news_bloc.dart';

abstract class CourseNewsState extends Equatable {
  const CourseNewsState();

  @override
  List<Object> get props => [];
}

class CourseNewsIsLoading extends CourseNewsState {}

class CourseNewsDidLoad extends CourseNewsState {
  const CourseNewsDidLoad({required this.news});

  final List<CourseNews> news;

  @override
  List<Object> get props => [news];
}

class CourseNewsError extends CourseNewsState {
  const CourseNewsError({required this.errorMessage});

  final String errorMessage;
}
