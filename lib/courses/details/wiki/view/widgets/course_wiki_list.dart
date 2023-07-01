import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/courses/details/wiki/bloc/course_wiki_bloc.dart';
import 'package:studipadawan/courses/details/wiki/view/widgets/course_wiki_list_row.dart';
import 'package:studipadawan/utils/empty_view.dart';
import 'package:studipadawan/utils/refreshable_content.dart';
import 'package:studipadawan/utils/widgets/error_view/error_view.dart';

class CourseWikiList extends StatelessWidget {
  const CourseWikiList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseWikiBloc, CourseWikiState>(
      builder: (context, state) {
        switch (state) {
          case final CourseWikiStateDidLoad s when s.wikiPages.isEmpty:
            return RefreshableContent(
              callback: () async => context
                  .read<CourseWikiBloc>()
                  .add(CourseWikiReloadRequested()),
              child: const EmptyView(
                title: 'Keine Wiki-Seiten vorhanden',
                message:
                    'Ziehe die Ansicht nach unten, um neue Wiki-Seiten zu laden.',
              ),
            );
          case CourseWikiStateDidLoad _:
            return RefreshIndicator(
              onRefresh: () async => context
                  .read<CourseWikiBloc>()
                  .add(CourseWikiReloadRequested()),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final wikiPage = state.wikiPages.elementAt(index);
                  return CourseWikiListRow(
                    wikiPage: wikiPage,
                  );
                },
                itemCount: state.wikiPages.length,
              ),
            );

          case CourseWikiStateError _:
            return ErrorView(
              iconData: null,
              message: state.errorMessage,
              onRetryPressed: () async => context
                  .read<CourseWikiBloc>()
                  .add(CourseWikiReloadRequested()),
            );

          case CourseWikiStateLoading _:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}
