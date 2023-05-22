import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studipadawan/courses/bloc/courses_bloc.dart';
import 'package:studipadawan/courses/bloc/courses_event.dart';
import 'package:studipadawan/courses/bloc/courses_state.dart';

import '../../helpers/hydrated_bloc.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockCourseRepository extends Mock implements CourseRepository {}

void main() {
  initHydratedBloc();
  late MockCourseRepository mockedCourseRepository;
  late MockAuthenticationRepository mockedAuthenticationRepository;

  setUp(() {
    mockedCourseRepository = MockCourseRepository();
    mockedAuthenticationRepository = MockAuthenticationRepository();
  });

  Course createCourse({required String courseId, required String semesterId}) {
    return Course(
      id: courseId,
      courseDetails: CourseDetails(title: 'title $courseId'),
      semesterId: semesterId,
    );
  }

  Semester createSemester({
    required String semesterId,
    required DateTime start,
    required DateTime end,
    required List<Course> courses,
  }) {
    return Semester(
      id: 'semester $semesterId',
      title: 'title $semesterId',
      start: start,
      end: end,
      startOfLectures: start,
      endOfLectures: end,
      courses: courses,
    );
  }

  final Semester semester1 = createSemester(
    semesterId: '1',
    start: DateTime(2024),
    end: DateTime(2024, 6),
    courses: [
      createCourse(courseId: '1', semesterId: '1'),
      createCourse(courseId: '2', semesterId: '1')
    ],
  );
  final Semester semester2 = createSemester(
    semesterId: '2',
    start: DateTime(2023),
    end: DateTime(2023, 6),
    courses: [
      createCourse(courseId: '3', semesterId: '2'),
      createCourse(courseId: '4', semesterId: '2')
    ],
  );

  group('serialization and deserialization related to HydratedBloc', () {
    test('toJson', () {
      final sut = CoursesBloc(
        courseRepository: mockedCourseRepository,
        authenticationRepository: mockedAuthenticationRepository,
      );

      // all and asc
      final Map<String, dynamic>? jsonMap1 = sut.toJson(
        const CoursesStateLoading(
          semesterFilter: SemesterFilter.all,
          semesterSortOrder: SemesterSortOrder.asc,
        ),
      );
      expect(jsonMap1, {'semesterFilter': 'all', 'semesterSortOrder': 'asc'});

      // current and desc
      final Map<String, dynamic>? jsonMap2 = sut.toJson(
        const CoursesStateLoading(
          semesterFilter: SemesterFilter.current,
          semesterSortOrder: SemesterSortOrder.desc,
        ),
      );
      expect(
        jsonMap2,
        {'semesterFilter': 'current', 'semesterSortOrder': 'desc'},
      );
    });

    test('fromJson', () {
      final sut = CoursesBloc(
        courseRepository: mockedCourseRepository,
        authenticationRepository: mockedAuthenticationRepository,
      );

      // all and asc
      final CoursesState? stateFromMap1 =
          sut.fromJson({'semesterFilter': 'all', 'semesterSortOrder': 'asc'});
      expect(stateFromMap1?.semesterFilter, SemesterFilter.all);
      expect(stateFromMap1?.semesterSortOrder, SemesterSortOrder.asc);

      // current and desc
      final CoursesState? stateFromMap2 = sut
          .fromJson({'semesterFilter': 'current', 'semesterSortOrder': 'desc'});
      expect(stateFromMap2?.semesterFilter, SemesterFilter.current);
      expect(stateFromMap2?.semesterSortOrder, SemesterSortOrder.desc);
    });
  });

  group('Load semesters', () {
    blocTest<CoursesBloc, CoursesState>(
      'sort order asc and all semester',
      setUp: () {
        when(
          () => mockedAuthenticationRepository.currentUser,
        ).thenAnswer((_) => const User('1'));

        when(
          () => mockedCourseRepository.getCoursesGroupedBySemester('1'),
        ).thenAnswer(
          (_) async => [semester1, semester2],
        );
      },
      build: () => CoursesBloc(
        courseRepository: mockedCourseRepository,
        authenticationRepository: mockedAuthenticationRepository,
        initialFilter: SemesterFilter.all,
        initialSortOrder: SemesterSortOrder.asc,
      ),
      act: (bloc) => bloc.add(CoursesRequested()),
      expect: () => [
        const CoursesStateLoading(
          semesterFilter: SemesterFilter.all,
          semesterSortOrder: SemesterSortOrder.asc,
        ),
        CoursesStateDidLoad(
          semesterFilter: SemesterFilter.all,
          semesterSortOrder: SemesterSortOrder.asc,
          semesters: [semester2, semester1],
        )
      ],
    );

    blocTest<CoursesBloc, CoursesState>(
      'sort order desc and all semester',
      setUp: () {
        when(
          () => mockedAuthenticationRepository.currentUser,
        ).thenAnswer((_) => const User('1'));

        when(
          () => mockedCourseRepository.getCoursesGroupedBySemester('1'),
        ).thenAnswer(
          (_) async => [semester1, semester2],
        );
      },
      build: () => CoursesBloc(
        courseRepository: mockedCourseRepository,
        authenticationRepository: mockedAuthenticationRepository,
        initialFilter: SemesterFilter.all,
        initialSortOrder: SemesterSortOrder.desc,
      ),
      act: (bloc) => bloc.add(CoursesRequested()),
      expect: () => [
        const CoursesStateLoading(
          semesterFilter: SemesterFilter.all,
          semesterSortOrder: SemesterSortOrder.desc,
        ),
        CoursesStateDidLoad(
          semesterFilter: SemesterFilter.all,
          semesterSortOrder: SemesterSortOrder.desc,
          semesters: [semester1, semester2],
        )
      ],
    );

    blocTest<CoursesBloc, CoursesState>(
      'sort order desc and only current semester',
      setUp: () {
        when(
          () => mockedAuthenticationRepository.currentUser,
        ).thenAnswer((_) => const User('1'));

        when(
          () => mockedCourseRepository.getCoursesGroupedBySemester('1'),
        ).thenAnswer(
          (_) async => [semester1, semester2],
        );
      },
      build: () => CoursesBloc(
        courseRepository: mockedCourseRepository,
        authenticationRepository: mockedAuthenticationRepository,
        initialFilter: SemesterFilter.current,
        initialSortOrder: SemesterSortOrder.desc,
      ),
      act: (bloc) => bloc.add(CoursesRequested()),
      expect: () => [
        const CoursesStateLoading(
          semesterFilter: SemesterFilter.current,
          semesterSortOrder: SemesterSortOrder.desc,
        ),
        CoursesStateDidLoad(
          semesterFilter: SemesterFilter.current,
          semesterSortOrder: SemesterSortOrder.desc,
          semesters: [semester2],
        )
      ],
    );
  });

  group('Change Filter', () {
    blocTest<CoursesBloc, CoursesState>(
      'change from current to all filter',
      setUp: () {
        when(
          () => mockedAuthenticationRepository.currentUser,
        ).thenAnswer((_) => const User('1'));

        when(
          () => mockedCourseRepository.getCoursesGroupedBySemester('1'),
        ).thenAnswer(
          (_) async => [semester1, semester2],
        );
      },
      build: () => CoursesBloc(
        courseRepository: mockedCourseRepository,
        authenticationRepository: mockedAuthenticationRepository,
        initialFilter: SemesterFilter.current,
        initialSortOrder: SemesterSortOrder.desc,
      ),
      act: (bloc) => bloc
        ..add(CoursesRequested())
        ..add(
          const SemesterFilterChanged(
            selectedSemesterFilter: SemesterFilter.all,
          ),
        ),
      expect: () => [
        const CoursesStateLoading(
          semesterFilter: SemesterFilter.current,
          semesterSortOrder: SemesterSortOrder.desc,
        ),
        CoursesStateDidLoad(
          semesterFilter: SemesterFilter.current,
          semesterSortOrder: SemesterSortOrder.desc,
          semesters: [semester2],
        ),
        CoursesStateDidLoad(
          semesterFilter: SemesterFilter.all,
          semesterSortOrder: SemesterSortOrder.desc,
          semesters: [semester1, semester2],
        )
      ],
    );
  });

  group('Change sort order', () {
    blocTest<CoursesBloc, CoursesState>(
      'change from asc to desc',
      setUp: () {
        when(
          () => mockedAuthenticationRepository.currentUser,
        ).thenAnswer((_) => const User('1'));

        when(
          () => mockedCourseRepository.getCoursesGroupedBySemester('1'),
        ).thenAnswer(
          (_) async => [semester1, semester2],
        );
      },
      build: () => CoursesBloc(
        courseRepository: mockedCourseRepository,
        authenticationRepository: mockedAuthenticationRepository,
        initialFilter: SemesterFilter.all,
        initialSortOrder: SemesterSortOrder.asc,
      ),
      act: (bloc) => bloc
        ..add(CoursesRequested())
        ..add(
          const SemesterSortOrderChanged(
            selectedSemesterSortOrder: SemesterSortOrder.desc,
          ),
        ),
      expect: () => [
        const CoursesStateLoading(
          semesterFilter: SemesterFilter.all,
          semesterSortOrder: SemesterSortOrder.asc,
        ),
        CoursesStateDidLoad(
          semesterFilter: SemesterFilter.all,
          semesterSortOrder: SemesterSortOrder.asc,
          semesters: [semester2, semester1],
        ),
        CoursesStateDidLoad(
          semesterFilter: SemesterFilter.all,
          semesterSortOrder: SemesterSortOrder.desc,
          semesters: [semester1, semester2],
        )
      ],
    );
  });
}
