part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();

  @override
  List<Object> get props => [];
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();

  @override
  List<Object?> get props => [];
}

final class ProfilePopulated extends ProfileState {
  const ProfilePopulated({required this.user});

  final UserResponseItem user;

  @override
  List<Object?> get props => [user];
}

final class ProfileFailure extends ProfileState {
  const ProfileFailure({required this.error});

  final String error;

  @override
  List<Object?> get props => [error];
}
