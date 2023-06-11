part of 'course_wiki_bloc.dart';

sealed class CourseWikiState extends Equatable {}

class CourseWikiStateLoading extends CourseWikiState {
  @override
  List<Object?> get props => [];
}

class CourseWikiStateDidLoad extends CourseWikiState {
  CourseWikiStateDidLoad({
    required this.wikiPages,
    required this.maxReached,
    required this.paginationLoading,
  });

  final List<CourseWikiPageData> wikiPages;
  final bool maxReached;
  final bool paginationLoading;

  CourseWikiStateDidLoad copyWith({
    List<CourseWikiPageData>? wikiPages,
    bool? maxReached,
    bool? paginationLoading,
  }) {
    return CourseWikiStateDidLoad(
      wikiPages: wikiPages ?? this.wikiPages,
      maxReached: maxReached ?? this.maxReached,
      paginationLoading: paginationLoading ?? this.paginationLoading,
    );
  }

  @override
  List<Object?> get props => [wikiPages, maxReached, paginationLoading];
}

class CourseWikiStateError extends CourseWikiState {
  CourseWikiStateError({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
