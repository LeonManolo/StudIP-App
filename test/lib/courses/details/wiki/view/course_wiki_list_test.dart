import 'package:bloc_test/bloc_test.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studipadawan/courses/details/wiki/bloc/course_wiki_bloc.dart';
import 'package:studipadawan/courses/details/wiki/view/widgets/course_wiki_list.dart';
import 'package:studipadawan/courses/details/wiki/view/widgets/course_wiki_list_row.dart';
import 'package:studipadawan/utils/empty_view.dart';
import 'package:studipadawan/utils/widgets/error_view/error_view.dart';

class MockCourseWikiBloc extends MockBloc<CourseWikiEvent, CourseWikiState>
    implements CourseWikiBloc {}

void main() {
  late CourseWikiBloc courseWikiBloc;

  setUp(() {
    courseWikiBloc = MockCourseWikiBloc();
  });

  group('displays corrects states', () {
    Future<void> setUpCourseWikiList(WidgetTester tester) async {
      return tester.pumpWidget(
        BlocProvider.value(
          value: courseWikiBloc,
          child: const MaterialApp(
            home: Scaffold(
              body: CourseWikiList(),
            ),
          ),
        ),
      );
    }

    testWidgets('displays LoadingIndicator on loading', (tester) async {
      when(
        () => courseWikiBloc.state,
      ).thenReturn(
        CourseWikiStateLoading(),
      );

      await setUpCourseWikiList(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays EmptyView if no wiki pages are present',
        (tester) async {
      when(
        () => courseWikiBloc.state,
      ).thenReturn(
        CourseWikiStateDidLoad(wikiPages: const []),
      );

      await setUpCourseWikiList(tester);
      await tester.pumpAndSettle();

      expect(find.byType(EmptyView), findsOneWidget);
    });

    testWidgets('displays row for each wiki page', (tester) async {
      final wikiPages =
          List.generate(5, (index) => _generateWikiPageData(id: index));
      when(
        () => courseWikiBloc.state,
      ).thenReturn(
        CourseWikiStateDidLoad(
          wikiPages: wikiPages,
        ),
      );

      await setUpCourseWikiList(tester);
      await tester.pumpAndSettle();

      for (final wikiPageData in wikiPages) {
        expect(
          find.widgetWithText(CourseWikiListRow, wikiPageData.title),
          findsOneWidget,
        );
      }
    });

    testWidgets('displays ErrorView', (tester) async {
      when(
        () => courseWikiBloc.state,
      ).thenReturn(
        CourseWikiStateError(errorMessage: 'some error message'),
      );

      await setUpCourseWikiList(tester);
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(ErrorView, 'some error message'),
        findsOneWidget,
      );
    });
  });
}

CourseWikiPageData _generateWikiPageData({required int id}) {
  return CourseWikiPageData(
    id: '$id',
    title: 'title_$id',
    content: 'content_$id',
    lastEditorAuthor:
        ItemAuthor(id: '$id', formattedName: 'author_$id', avatarUrl: ''),
    lastEditedAt: DateTime(2023, 06, 14),
  );
}
