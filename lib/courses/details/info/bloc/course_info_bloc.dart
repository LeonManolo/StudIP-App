import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'course_info_event.dart';
part 'course_info_state.dart';

class CourseInfoBloc extends Bloc<CourseInfoEvent, CourseInfoState> {
  CourseInfoBloc() : super(CourseInfoInitial()) {
    on<CourseInfoEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
