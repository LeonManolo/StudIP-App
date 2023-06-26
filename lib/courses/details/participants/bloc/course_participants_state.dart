part of 'course_participants_bloc.dart';

sealed class CourseParticipantsState extends Equatable {
  const CourseParticipantsState();
}

final class CourseParticipantsLoading extends CourseParticipantsState {
  const CourseParticipantsLoading();
  @override
  List<Object?> get props => [];
}

final class CourseParticipantsDidLoad extends CourseParticipantsState {
  const CourseParticipantsDidLoad({
    required this.participants,
    required this.maxReached,
    required this.paginationLoading,
  });

  final List<Participant> participants;
  final bool maxReached;
  final bool paginationLoading;

  CourseParticipantsDidLoad copyWith({
    List<Participant>? participants,
    bool? maxReached,
    bool? paginationLoading,
  }) {
    return CourseParticipantsDidLoad(
      participants: participants ?? this.participants,
      maxReached: maxReached ?? this.maxReached,
      paginationLoading: paginationLoading ?? this.paginationLoading,
    );
  }

  @override
  List<Object?> get props => [participants, maxReached, paginationLoading];
}

final class CourseParticipantsError extends CourseParticipantsState {
  const CourseParticipantsError({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
