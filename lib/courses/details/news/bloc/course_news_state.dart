part of 'course_news_bloc.dart';

sealed class CourseNewsState extends Equatable {}

class CourseNewsStateLoading extends CourseNewsState {
  @override
  List<Object?> get props => [];
}

class CourseNewsStateDidLoad extends CourseNewsState {
  CourseNewsStateDidLoad({
    required this.news,
    required this.maxReached,
    required this.paginationLoading,
  });

  final List<CourseNews> news;
  final bool maxReached;
  final bool paginationLoading;

  CourseNewsStateDidLoad copyWith({
    List<CourseNews>? news,
    bool? maxReached,
    bool? paginationLoading,
  }) {
    return CourseNewsStateDidLoad(
      news: news ?? this.news,
      maxReached: maxReached ?? this.maxReached,
      paginationLoading: paginationLoading ?? this.paginationLoading,
    );
  }

  @override
  List<Object?> get props => [news, maxReached, paginationLoading];
}

class CourseNewsStateError extends CourseNewsState {
  CourseNewsStateError({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
