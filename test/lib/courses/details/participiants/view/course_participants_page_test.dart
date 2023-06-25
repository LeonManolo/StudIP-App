import 'dart:io';

import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:studipadawan/courses/details/participants/view/course_participants_page.dart';
import 'package:studipadawan/courses/details/participants/widgets/course_participant_list_tile.dart';
import 'package:studipadawan/utils/widgets/error_view/error_view.dart';

class MockCourseRepository extends Mock implements CourseRepository {}

void main() {
  late CourseRepository courseRepository;

  setUp(() {
    courseRepository = MockCourseRepository();
    HttpOverrides.global = null;
  });

  group('displays corrects data', () {
    Participant generateParticipant({required String id}) {
      return Participant(
        id: id,
        username: 'username_$id',
        formattedName: '',
        familyName: 'familyName_$id',
        givenName: 'givenName_$id',
        permission: '',
        email: 'email_$id',
        phone: '',
        homepage: '',
        address: '',
        avatarUrl: '',
        namePrefix: '',
        nameSuffix: '',
      );
    }

    testWidgets('displays correct data for course participants',
        (tester) async {
      when(
        () => courseRepository.getCourseParticipants(
          courseId: any(named: 'courseId'),
          offset: any(named: 'offset'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((invocation) async {
        return CourseParticipantsData(
          participants:
              List.generate(5, (index) => generateParticipant(id: '$index')),
          totalParticipants: 5,
        );
      });

      await mockNetworkImages(() async {
        await tester.pumpWidget(
          RepositoryProvider<CourseRepository>.value(
            value: courseRepository,
            child: const MaterialApp(
              home: Scaffold(
                body: CourseParticipantsPage(
                  courseId: '1',
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        for (int i = 0; i < 5; i++) {
          expect(
            find.descendant(
              of: find.byType(CourseParticipantListTile),
              matching: find.text('familyName_$i, givenName_$i'),
            ),
            findsOneWidget,
          );
          expect(
            find.descendant(
              of: find.byType(CourseParticipantListTile),
              matching: find.text('email_$i'),
            ),
            findsOneWidget,
          );
        }
      });
    });

    testWidgets('displays correct error data', (tester) async {
      when(
        () => courseRepository.getCourseParticipants(
          courseId: any(named: 'courseId'),
          offset: any(named: 'offset'),
          limit: any(named: 'limit'),
        ),
      ).thenThrow('an error occured');

      await tester.pumpWidget(
        RepositoryProvider<CourseRepository>.value(
          value: courseRepository,
          child: const MaterialApp(
            home: Scaffold(
              body: CourseParticipantsPage(
                courseId: '1',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(ErrorView),
          matching:
              find.text('Beim Laden der Teilnehmer ist ein Fehler aufgetreten'),
        ),
        findsOneWidget,
      );
    });
  });
}
