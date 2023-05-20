import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/courses/details/wiki/bloc/course_wiki_bloc.dart';
import 'package:studipadawan/courses/details/wiki/view/widgets/course_wiki_list_row.dart';
import 'package:studipadawan/utils/empty_view.dart';
import 'package:studipadawan/utils/paginated_list.dart';
import 'package:studipadawan/utils/pagination_loading_indicator.dart';
import 'package:studipadawan/utils/refreshable_content.dart';

class CourseWikiList extends PaginatedList {
  const CourseWikiList({super.key, required super.reachedBottom});

  @override
  // ignore: library_private_types_in_public_api
  _CourseWikiListState createState() => _CourseWikiListState();
}

class _CourseWikiListState extends PaginatedListState {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseWikiBloc, CourseWikiState>(
        builder: (context, state) {
      switch (state) {
        case final CourseWikiStateDidLoad s when s.wikiPages.isEmpty:
          return RefreshableContent(
            callback: () =>
                context.read<CourseWikiBloc>().add(CourseWikiReloadRequested()),
            child: const EmptyView(
              title: 'Keine Wiki-Seiten vorhanden',
              message:
                  'Ziehe die Ansicht nach unten, um neue Wiki-Seiten zu laden.',
            ),
          );
        case CourseWikiStateDidLoad _:
          return RefreshableContent(
            callback: () async =>
                context.read<CourseWikiBloc>().add(CourseWikiReloadRequested()),
            child: ListView.builder(
              itemBuilder: (context, index) {
                if (index >= state.wikiPages.length) {
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
                  final wikiPage = state.wikiPages.elementAt(index);
                  return CourseWikiListRow(
                    wikiPage: wikiPage,
                  );
                }
              },
              itemCount: state.wikiPages.length + 1,
              controller: paginatedScrollController,
            ),
          );

        case CourseWikiStateError _:
          return Center(
            child: Text(
              state.errorMessage,
              textAlign: TextAlign.center,
            ),
          );

        case CourseWikiStateLoading _:
          return const Center(
            child: CircularProgressIndicator(),
          );
      }
    });
  }
}
