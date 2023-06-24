import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studipadawan/courses/bloc/courses_bloc.dart';
import 'package:studipadawan/courses/bloc/courses_event.dart';
import 'package:studipadawan/courses/bloc/courses_state.dart';
import 'package:studipadawan/courses/view/widgets/courses_page_body.dart';
import 'package:studipadawan/courses/view/widgets/semester_list.dart';
import 'package:studipadawan/utils/loading_indicator.dart';
import 'package:studipadawan/utils/widgets/error_view/error_view.dart';

class MockCoursesBloc extends MockBloc<CourseEvent, CoursesState>
    implements CoursesBloc {}

void main() {
  late CoursesBloc coursesBloc;

  setUp(() {
    coursesBloc = MockCoursesBloc();
  });

  group('displays correct states', () {
    testWidgets('displays LoadingIndicator', (tester) async {
      when(() => coursesBloc.state).thenReturn(
        const CoursesStateLoading(
          semesterFilter: SemesterFilter.all,
          semesterSortOrder: SemesterSortOrder.asc,
        ),
      );

      await tester.pumpWidget(
        BlocProvider.value(
          value: coursesBloc,
          child: const MaterialApp(home: Scaffold(body: CoursesPageBody())),
        ),
      );

      expect(find.byType(LoadingIndicator), findsOneWidget);
    });

    testWidgets('displays CoursesList', (tester) async {
      when(() => coursesBloc.state).thenReturn(
        const CoursesStateDidLoad(
          semesterFilter: SemesterFilter.all,
          semesterSortOrder: SemesterSortOrder.asc,
          semesters: [],
        ),
      );

      await tester.pumpWidget(
        BlocProvider.value(
          value: coursesBloc,
          child: const MaterialApp(home: Scaffold(body: CoursesPageBody())),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CoursesList), findsOneWidget);
    });

    testWidgets('displays ErrorView', (tester) async {
      when(() => coursesBloc.state).thenReturn(
        const CoursesStateError(
          semesterFilter: SemesterFilter.all,
          semesterSortOrder: SemesterSortOrder.asc,
          errorMessage: 'some error message - widget test',
        ),
      );

      await tester.pumpWidget(
        BlocProvider.value(
          value: coursesBloc,
          child: const MaterialApp(home: Scaffold(body: CoursesPageBody())),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ErrorView), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(ErrorView),
          matching: find.text('some error message - widget test'),
        ),
        findsOneWidget,
      );
    });
  });
}
