import 'package:bloc/bloc.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

part 'course_wiki_event.dart';
part 'course_wiki_state.dart';

class CourseWikiBloc extends Bloc<CourseWikiEvent, CourseWikiState> {
  CourseWikiBloc({
    required CourseRepository courseRepository,
    required this.courseId,
  })  : _courseRepository = courseRepository,
        super(CourseWikiStateLoading()) {
    on<CourseWikiReloadRequested>(_onCourseWikiReloadRequested);
  }

  final CourseRepository _courseRepository;
  final String courseId;

  Future<void> _onCourseWikiReloadRequested(
    CourseWikiReloadRequested event,
    Emitter<CourseWikiState> emit,
  ) async {
    emit(CourseWikiStateLoading());

    try {
      final wikiPages = await _courseRepository.getWikiPages(
        courseId: courseId,
      );

      final wikiStartPageIndex =
          wikiPages.indexWhere((wikiPage) => wikiPage.title == 'WikiWikiWeb');
      if (wikiStartPageIndex >= 0) {
        wikiPages[wikiStartPageIndex] =
            wikiPages[wikiStartPageIndex].updateTitle(newTitle: 'Startseite');
      }

      wikiPages.sort(
        (wikiPage1, wikiPage2) =>
            wikiPage2.lastEditedAt.compareTo(wikiPage1.lastEditedAt),
      );

      emit(CourseWikiStateDidLoad(wikiPages: wikiPages));
    } catch (e) {
      Logger().e(e);
      emit(
        CourseWikiStateError(
          errorMessage:
              'Beim Laden der Wiki-Seiten ist ein Fehler aufgetreten.',
        ),
      );
    }
  }
}
