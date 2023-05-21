part of 'pagination_bloc.dart';

sealed class PaginationState<ItemData> extends Equatable {
  const PaginationState();

  @override
  List<Object> get props => [];
}

class PaginatedListLoading<ItemData> extends PaginationState<ItemData> {}

class PaginatedListDidLoad<ItemData> extends PaginationState<ItemData> {
  const PaginatedListDidLoad({
    required this.items,
    required this.maxReached,
    required this.paginationLoading,
  });

  final List<ItemData> items;
  final bool maxReached;
  final bool paginationLoading;

  @override
  List<Object> get props => [items, maxReached, paginationLoading];
}

class PaginatedListError<ItemData> extends PaginationState<ItemData> {
  const PaginatedListError({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
