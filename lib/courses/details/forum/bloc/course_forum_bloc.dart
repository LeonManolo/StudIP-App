import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'course_forum_event.dart';
part 'course_forum_state.dart';

class CourseForumBloc extends Bloc<CourseForumEvent, CourseForumState> {
  CourseForumBloc() : super(CourseForumInitial()) {
    on<CourseForumEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
