import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'course_participants_event.dart';
part 'course_participants_state.dart';

class CourseParticipantsBloc
    extends Bloc<CourseParticipantsEvent, CourseParticipantsState> {
  CourseParticipantsBloc() : super(CourseParticipantsInitial()) {
    on<CourseParticipantsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
