import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/courses/details/news/bloc/course_news_bloc.dart';
import 'package:studipadawan/courses/details/news/view/widgets/course_news_card.dart';
import 'package:studipadawan/utils/empty_view.dart';
import 'package:studipadawan/utils/paginated_list.dart';
import 'package:studipadawan/utils/pagination_loading_indicator.dart';
import 'package:studipadawan/utils/refreshable_content.dart';

class CourseNewsList extends PaginatedList {
  const CourseNewsList({super.key, required super.reachedBottom});

  @override
  // ignore: library_private_types_in_public_api
  _CourseNewsListState createState() => _CourseNewsListState();
}

class _CourseNewsListState extends PaginatedListState {
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
                          height: AppSpacing.lg,
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
                        AppSpacing.lg,
                        AppSpacing.lg,
                        AppSpacing.lg,
                        0,
                      ),
                      child: CourseNewsCard(news: newsItem),
                    );
                  }
                },
                itemCount: state.news.length + 1,
                controller: paginatedScrollController,
              ),
            );

          case CourseNewsStateError _:
            return Center(
              child: Text(
                state.errorMessage,
                textAlign: TextAlign.center,
              ),
            );

          case CourseNewsStateLoading _:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}
