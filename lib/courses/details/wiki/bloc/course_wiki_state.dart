part of 'course_wiki_bloc.dart';

sealed class CourseWikiState extends Equatable {}

class CourseWikiStateLoading extends CourseWikiState {
  @override
  List<Object?> get props => [];
}

class CourseWikiStateDidLoad extends CourseWikiState {
  CourseWikiStateDidLoad({
    required this.wikiPages,
  });

  final List<CourseWikiPageData> wikiPages;

  @override
  List<Object?> get props => [wikiPages];
}

class CourseWikiStateError extends CourseWikiState {
  CourseWikiStateError({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
