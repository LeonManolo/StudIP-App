import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'course_wiki_event.dart';
part 'course_wiki_state.dart';

class CourseWikiBloc extends Bloc<CourseWikiEvent, CourseWikiState> {
  CourseWikiBloc() : super(CourseWikiInitial()) {
    on<CourseWikiEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
