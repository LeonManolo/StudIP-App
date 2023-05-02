abstract class ItemListResponse<I> {
  List<I> get items;
  int get offset;
  int get limit;
  int get total;
}
