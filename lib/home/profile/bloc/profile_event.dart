part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

final class ProfileRequested extends ProfileEvent {
  @override
  List<Object?> get props => [];
}
