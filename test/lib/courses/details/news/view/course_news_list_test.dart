import 'package:bloc_test/bloc_test.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:studipadawan/courses/details/news/bloc/course_news_bloc.dart';
import 'package:studipadawan/courses/details/news/view/widgets/course_news_card.dart';
import 'package:studipadawan/courses/details/news/view/widgets/course_news_list.dart';
import 'package:studipadawan/utils/empty_view.dart';
import 'package:studipadawan/utils/widgets/error_view/error_view.dart';

class MockCourseNewsBloc extends MockBloc<CourseNewsEvent, CourseNewsState>
    implements CourseNewsBloc {}

void main() {
  late CourseNewsBloc courseNewsBloc;

  setUp(() {
    courseNewsBloc = MockCourseNewsBloc();
  });

  group('displays corrects states', () {
    Future<void> setUpCourseNewsList(WidgetTester tester) async {
      return tester.pumpWidget(
        BlocProvider.value(
          value: courseNewsBloc,
          child: MaterialApp(
            home: Scaffold(
              body: CourseNewsList(
                reachedBottom: () {},
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('displays LoadingIndicator on loading', (tester) async {
      when(
        () => courseNewsBloc.state,
      ).thenReturn(
        CourseNewsStateLoading(),
      );

      await setUpCourseNewsList(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays EmptyView if no news pages are present',
        (tester) async {
      when(
        () => courseNewsBloc.state,
      ).thenReturn(
        CourseNewsStateDidLoad(
            maxReached: true, paginationLoading: false, news: const []),
      );

      await setUpCourseNewsList(tester);
      await tester.pumpAndSettle();

      expect(find.byType(EmptyView), findsOneWidget);
    });

    testWidgets('displays row for each news page', (tester) async {
      final news = List.generate(5, (index) => _generateCourseNews(id: index));
      when(
        () => courseNewsBloc.state,
      ).thenReturn(
        CourseNewsStateDidLoad(
          news: news,
          maxReached: true,
          paginationLoading: false,
        ),
      );

      await mockNetworkImages(() async {
        await setUpCourseNewsList(tester);
        await tester.pumpAndSettle();

        for (final newsItem in news) {
          expect(
            find.widgetWithText(CourseNewsCard, newsItem.title),
            findsOneWidget,
          );
        }
      });
    });

    testWidgets('displays ErrorView', (tester) async {
      when(
        () => courseNewsBloc.state,
      ).thenReturn(
        CourseNewsStateError(errorMessage: 'some course news error message'),
      );

      await setUpCourseNewsList(tester);
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(ErrorView, 'some course news error message'),
        findsOneWidget,
      );
    });
  });
}

CourseNews _generateCourseNews({required int id}) {
  return CourseNews(
    id: '$id',
    title: 'title_$id',
    content: 'content_$id',
    publicationStart: DateTime(2023, 6, 14, 13, 30),
    publicationEnd: DateTime(2023, 6, 16, 13, 30),
    author: ItemAuthor(id: 'author_$id', formattedName: '', avatarUrl: ''),
  );
}
