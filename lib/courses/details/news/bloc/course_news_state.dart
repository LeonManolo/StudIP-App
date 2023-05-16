part of 'course_news_bloc.dart';

enum CourseNewsStatus { error, isLoading, didLoad }

class CourseNewsState extends Equatable {
  const CourseNewsState({
    required this.news,
    required this.maxReached,
    required this.paginationLoading,
    required this.status,
    required this.errorMessage,
  });

  factory CourseNewsState.inital() {
    return CourseNewsState(
      news: List.empty(),
      maxReached: false,
      paginationLoading: false,
      status: CourseNewsStatus.isLoading,
      errorMessage: '',
    );
  }

  final List<CourseNews> news;
  final bool maxReached;

  final bool paginationLoading;
  final CourseNewsStatus status;
  final String errorMessage;

  @override
  List<Object> get props =>
      [news, maxReached, paginationLoading, status, errorMessage];

  CourseNewsState copyWith({
    List<CourseNews>? news,
    bool? maxReached,
    bool? paginationLoading,
    CourseNewsStatus? status,
    String? errorMessage,
  }) {
    return CourseNewsState(
      news: news ?? this.news,
      maxReached: maxReached ?? this.maxReached,
      paginationLoading: paginationLoading ?? this.paginationLoading,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
