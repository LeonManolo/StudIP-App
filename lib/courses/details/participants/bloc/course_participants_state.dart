part of 'course_participants_bloc.dart';

abstract class CourseParticipantsState extends Equatable {
  const CourseParticipantsState();
  
  @override
  List<Object> get props => [];
}

class CourseParticipantsInitial extends CourseParticipantsState {}
