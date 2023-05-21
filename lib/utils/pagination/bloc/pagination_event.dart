part of 'pagination_bloc.dart';

abstract class PaginationEvent extends Equatable {
  const PaginationEvent();

  @override
  List<Object> get props => [];
}

class PaginatedListReloadRequested extends PaginationEvent {}

class PaginatedListReachedBottom extends PaginationEvent {}
