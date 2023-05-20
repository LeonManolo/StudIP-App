import 'package:flutter/material.dart';

abstract class PaginatedList extends StatefulWidget {
  const PaginatedList({super.key, required this.reachedBottom});
  final void Function() reachedBottom;
}

abstract class PaginatedListState extends State<PaginatedList> {
  final paginatedScrollController = ScrollController();

  late void Function() reachedBottom;

  @override
  void initState() {
    paginatedScrollController.addListener(_onScroll);
    reachedBottom = widget.reachedBottom;
    super.initState();
  }

  // https://bloclibrary.dev/#/flutterinfinitelisttutorial?id=presentation-layer
  @override
  void dispose() {
    paginatedScrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom()) {
      reachedBottom();
    }
  }

  bool _isBottom() {
    if (!paginatedScrollController.hasClients) return false;
    final maxScroll = paginatedScrollController.position.maxScrollExtent;
    final currentScroll = paginatedScrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
