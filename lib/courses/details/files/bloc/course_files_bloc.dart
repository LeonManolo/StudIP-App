import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'course_files_event.dart';
part 'course_files_state.dart';

class CourseFilesBloc extends Bloc<CourseFilesEvent, CourseFilesState> {
  CourseFilesBloc() : super(CourseFilesInitial()) {
    on<CourseFilesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
