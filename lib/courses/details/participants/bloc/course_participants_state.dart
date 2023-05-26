part of 'course_participants_bloc.dart';

abstract class CourseParticipantsState extends Equatable {
  const CourseParticipantsState();
  
  @override
  List<Object> get props => [];
}

class CourseParticipantsInitial extends CourseParticipantsState {}

class CourseParticipantsDidLoad extends CourseParticipantsState {
  const CourseParticipantsDidLoad({
    required this.news,
    required this.maxReached,
    required this.paginationLoading,
  });

  final List<CourseNews> news;
  final bool maxReached;
  final bool paginationLoading;

  CourseParticipantsDidLoad copyWith({
    List<CourseNews>? news,
    bool? maxReached,
    bool? paginationLoading,
  }) {
    return CourseParticipantsDidLoad(
      news: news ?? this.news,
      maxReached: maxReached ?? this.maxReached,
      paginationLoading: paginationLoading ?? this.paginationLoading,
    );
  }

  @override
  List<Object?> get props => [news, maxReached, paginationLoading];
}

class CourseParticipantsError extends CourseParticipantsState {
  const CourseParticipantsError({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}