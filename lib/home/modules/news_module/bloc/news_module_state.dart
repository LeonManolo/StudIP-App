import 'package:equatable/equatable.dart';

sealed class NewsModuleState extends Equatable {
  const NewsModuleState();

  @override
  List<Object?> get props => [];
}

class NewsModuleStateInitial extends NewsModuleState {
  const NewsModuleStateInitial();

  @override
  List<Object?> get props => [];
}

class NewsModuleStateLoading extends NewsModuleState {
  const NewsModuleStateLoading();

  @override
  List<Object?> get props => [];
}

class NewsModuleStateDidLoad extends NewsModuleState {
  const NewsModuleStateDidLoad();

  @override
  List<Object?> get props => [];

  NewsModuleStateDidLoad copyWith() {
    return const NewsModuleStateDidLoad();
  }
}

class NewsModuleStateError extends NewsModuleState {
  const NewsModuleStateError();

  @override
  List<Object?> get props => [];

  NewsModuleStateError copyWith() {
    return const NewsModuleStateError();
  }
}
