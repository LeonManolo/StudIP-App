import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:studipadawan/courses/details/news/bloc/course_news_bloc.dart';
import 'package:studipadawan/utils/pagination_loading_indicator.dart';

class CourseNewsList extends StatefulWidget {
  const CourseNewsList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CourseNewsListState createState() => _CourseNewsListState();
}

class _CourseNewsListState extends State<CourseNewsList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseNewsBloc, CourseNewsState>(
      builder: (context, state) {
        switch (state.status) {
          case CourseNewsStatus.didLoad:
            return RefreshIndicator(
              onRefresh: () async => context
                  .read<CourseNewsBloc>()
                  .add(CourseNewsReloadRequested()),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  if (index >= state.news.length) {
                    return const PaginationLoadingIndicator(
                      visible: true,
                    );
                  } else {
                    final newsItem = state.news.elementAt(index);
                    return ListTile(
                      title: Text(newsItem.title),
                      subtitle: HtmlWidget(newsItem.content),
                    );
                  }
                },
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemCount: state.maxReached
                    ? state.news.length
                    : state.news.length + 1,
                controller: _scrollController,
              ),
            );

          case CourseNewsStatus.error:
            return Center(
              child: Text(state.errorMessage),
            );

          case CourseNewsStatus.isLoading:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }

  // https://bloclibrary.dev/#/flutterinfinitelisttutorial?id=presentation-layer
  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<CourseNewsBloc>().add(CourseNewsReachedBottom());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
