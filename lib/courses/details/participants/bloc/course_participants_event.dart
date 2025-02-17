part of 'course_participants_bloc.dart';

abstract class CourseParticipantsEvent extends Equatable {
  const CourseParticipantsEvent();

  @override
  List<Object> get props => [];
}

class CourseParticipantsRequested extends CourseParticipantsEvent {}

class CourseParticipantsReachedBottom extends CourseParticipantsEvent {}
