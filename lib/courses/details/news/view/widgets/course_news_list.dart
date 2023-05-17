import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/courses/details/news/bloc/course_news_bloc.dart';
import 'package:studipadawan/courses/details/news/view/widgets/course_news_card.dart';
import 'package:studipadawan/utils/empty_view.dart';
import 'package:studipadawan/utils/pagination_loading_indicator.dart';
import 'package:studipadawan/utils/refreshable_content.dart';

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
        switch (state) {
          case final CourseNewsStateDidLoad s when s.news.isEmpty:
            return RefreshableContent(
              callback: () => context
                  .read<CourseNewsBloc>()
                  .add(CourseNewsReloadRequested()),
              child: const EmptyView(
                title: 'Keine Ankündigungen vorhanden',
                message:
                    'Ziehe die Ansicht nach unten, um neue Ankündigungen zu laden.',
              ),
            );
          case CourseNewsStateDidLoad _:
            return RefreshIndicator(
              onRefresh: () async => context
                  .read<CourseNewsBloc>()
                  .add(CourseNewsReloadRequested()),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  if (index >= state.news.length) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: AppSpacing.xlg,
                        ),
                        PaginationLoadingIndicator(
                          visible: !state.maxReached,
                        ),
                      ],
                    );
                  } else {
                    final newsItem = state.news.elementAt(index);

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.xlg,
                        AppSpacing.xlg,
                        AppSpacing.xlg,
                        0,
                      ),
                      child: CourseNewsCard(news: newsItem),
                    );
                  }
                },
                itemCount: state.news.length + 1,
                controller: _scrollController,
              ),
            );

          case CourseNewsStateError _:
            return Center(
              child: Text(state.errorMessage),
            );

          case CourseNewsStateLoading _:
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
    if (_isBottom()) {
      context.read<CourseNewsBloc>().add(CourseNewsReachedBottom());
    }
  }

  bool _isBottom() {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
