import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'pagination_event.dart';
part 'pagination_state.dart';

abstract class ItemDataListResponse<ItemData> {
  ItemDataListResponse({required this.items, required this.totalNumberOfItems});

  final List<ItemData> items;
  final int totalNumberOfItems;
}

abstract class PaginationBloc<ItemData, Event extends PaginationEvent,
    State extends PaginationState<ItemData>> extends Bloc<Event, State> {
  PaginationBloc({required State initialState}) : super(initialState) {
    on<PaginatedListReloadRequested>(onPaginatedListReloadRequested);
  }

  Future<ItemDataListResponse<ItemData>> loadItems({required int offset});

  Future<void> onPaginatedListReloadRequested(
    PaginatedListReloadRequested event,
    Emitter<State> emit,
  ) async {
    emit(PaginatedListLoading<ItemData>() as State);
  }
}
