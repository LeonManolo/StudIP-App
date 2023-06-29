import 'package:activity_repository/activity_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studipadawan/home/cubit/home_cubit.dart';
import 'package:studipadawan/home/modules/bloc/module_bloc.dart';
import 'package:studipadawan/home/modules/calendar_module/model/calendar_preview_model.dart';
import 'package:studipadawan/home/modules/calendar_module/widgets/calendar_preview_tile.dart';
import 'package:studipadawan/home/modules/files_module/model/file_preview_model.dart';
import 'package:studipadawan/home/modules/files_module/widgets/files_preview_tile.dart';
import 'package:studipadawan/home/modules/message_module/bloc/message_module_bloc.dart';
import 'package:studipadawan/home/modules/message_module/model/message_preview_model.dart';
import 'package:studipadawan/home/modules/message_module/widgets/message_preview_tile.dart';
import 'package:studipadawan/home/modules/news_module/model/news_preview_model.dart';
import 'package:studipadawan/home/modules/news_module/widgets/news_preview_tile.dart';
import 'package:studipadawan/home/view/home_page.dart';
import 'package:studipadawan/home/view/widgets/module_card.dart';
import 'package:studipadawan/utils/empty_view.dart';
import 'package:studipadawan/utils/widgets/error_view/error_view.dart';

import '../../../helpers/hydrated_stoarge.dart';

class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

class MockMessageModuleBloc extends MockBloc<ModuleEvent, ModuleState>
    implements MessageModuleBloc {}

class MockFileModuleBloc extends MockBloc<ModuleEvent, ModuleState>
    implements MessageModuleBloc {}

class MockNewsModuleBloc extends MockBloc<ModuleEvent, ModuleState>
    implements MessageModuleBloc {}

class MockCalendarModuleBloc extends MockBloc<ModuleEvent, ModuleState>
    implements MessageModuleBloc {}

void main() {
  late MockMessageModuleBloc mockMessageModuleBloc;
  late MockFileModuleBloc mockFileModuleBloc;
  late MockNewsModuleBloc mockNewsModuleBloc;
  late MockCalendarModuleBloc mockCalendarModuleBloc;

  late HomeCubit sut;

  setUp(() {
    initHydratedStorage();
    sut = MockHomeCubit();
    mockMessageModuleBloc = MockMessageModuleBloc();
    mockFileModuleBloc = MockFileModuleBloc();
    mockNewsModuleBloc = MockNewsModuleBloc();
    mockCalendarModuleBloc = MockCalendarModuleBloc();

    when(
      () => sut.moduleBlocs,
    ).thenReturn({
      ModuleType.calendar: mockCalendarModuleBloc,
      ModuleType.files: mockFileModuleBloc,
      ModuleType.messages: mockMessageModuleBloc,
      ModuleType.news: mockNewsModuleBloc,
    });
  });

  group('displays selected modules', () {
    setUp(() {
      when(() => mockCalendarModuleBloc.emptyViewMessage)
          .thenReturn('empty calendar');
      when(() => mockMessageModuleBloc.emptyViewMessage)
          .thenReturn('empty messages');
      when(() => mockNewsModuleBloc.emptyViewMessage).thenReturn('empty news');
      when(() => mockFileModuleBloc.emptyViewMessage).thenReturn('empty files');
    });

    testWidgets('no modules visible', (tester) async {
      when(() => sut.state).thenReturn(const HomeState(selectedModules: []));
      await tester.pumpWidget(
        BlocProvider.value(
          value: sut,
          child: const MaterialApp(home: HomePageView()),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(EmptyView, 'Keine Module vorhanden'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(
          EmptyView,
          'Füge jetzt über den Edit-Button neue Module hinzu.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('all modules visible but empty', (tester) async {
      // arrange
      when(() => sut.state)
          .thenReturn(const HomeState(selectedModules: ModuleType.values));

      when(() => mockCalendarModuleBloc.state)
          .thenReturn(ModuleLoaded.initial());
      when(() => mockMessageModuleBloc.state)
          .thenReturn(ModuleLoaded.initial());
      when(() => mockNewsModuleBloc.state).thenReturn(ModuleLoaded.initial());
      when(() => mockFileModuleBloc.state).thenReturn(ModuleLoaded.initial());

      // act
      await tester.pumpWidget(
        BlocProvider.value(
          value: sut,
          child: const MaterialApp(home: HomePageView()),
        ),
      );
      await tester.pumpAndSettle();

      // assert
      expect(find.widgetWithText(ModuleCard, 'Ankündigungen'), findsOneWidget);
      expect(find.widgetWithText(EmptyView, 'empty news'), findsOneWidget);

      expect(find.widgetWithText(ModuleCard, 'Dateien'), findsOneWidget);
      expect(find.widgetWithText(EmptyView, 'empty files'), findsOneWidget);

      expect(find.widgetWithText(ModuleCard, 'Nachrichten'), findsOneWidget);
      expect(find.widgetWithText(EmptyView, 'empty messages'), findsOneWidget);

      expect(find.widgetWithText(ModuleCard, 'Kalender'), findsOneWidget);
      expect(find.widgetWithText(EmptyView, 'empty calendar'), findsOneWidget);
    });

    testWidgets('all modules visible but with error', (tester) async {
      // arrange
      when(() => sut.state)
          .thenReturn(const HomeState(selectedModules: ModuleType.values));

      when(() => mockCalendarModuleBloc.state)
          .thenReturn(const ModuleError(errorMessage: 'calendar error'));
      when(() => mockMessageModuleBloc.state)
          .thenReturn(const ModuleError(errorMessage: 'messages error'));
      when(() => mockNewsModuleBloc.state)
          .thenReturn(const ModuleError(errorMessage: 'news error'));
      when(() => mockFileModuleBloc.state)
          .thenReturn(const ModuleError(errorMessage: 'files error'));

      // act
      await tester.pumpWidget(
        BlocProvider.value(
          value: sut,
          child: const MaterialApp(home: HomePageView()),
        ),
      );
      await tester.pumpAndSettle();

      // assert
      expect(find.widgetWithText(ErrorView, 'news error'), findsOneWidget);
      expect(find.widgetWithText(ErrorView, 'files error'), findsOneWidget);
      expect(find.widgetWithText(ErrorView, 'messages error'), findsOneWidget);
      expect(find.widgetWithText(ErrorView, 'calendar error'), findsOneWidget);
    });

    testWidgets('all modules visible with valid data', (tester) async {
      // arrange
      when(() => sut.state)
          .thenReturn(const HomeState(selectedModules: ModuleType.values));

      when(() => mockCalendarModuleBloc.state).thenReturn(
        ModuleLoaded(previewModels: [_createCalendarPreviewModel(id: '1')]),
      );
      when(() => mockMessageModuleBloc.state).thenReturn(
        ModuleLoaded(previewModels: [_createMessagePreviewModel(id: '1')]),
      );
      when(() => mockNewsModuleBloc.state).thenReturn(
        ModuleLoaded(previewModels: [_createNewsPreviewModel(id: '1')]),
      );
      when(() => mockFileModuleBloc.state).thenReturn(
        ModuleLoaded(previewModels: [_createFilePreviewModel(id: '1')]),
      );

      // act
      await tester.pumpWidget(
        BlocProvider.value(
          value: sut,
          child: const MaterialApp(home: HomePageView()),
        ),
      );
      await tester.pumpAndSettle();

      // assert
      expect(find.byType(NewsPreviewTile), findsOneWidget);
      expect(find.byType(MessagePreviewTile), findsOneWidget);
      expect(find.byType(CalendarPreviewTile), findsOneWidget);
      expect(find.byType(FilePreviewTile), findsOneWidget);
    });
  });
}

NewsPreviewModel _createNewsPreviewModel({required String id}) {
  return NewsPreviewModel(
    newsActivity: NewsActivity(
      publicationStart: DateTime(2023, 06, 10, 14, 30),
      title: 'newsTitle_$id',
      publicationEnd: DateTime(2023, 10, 10, 14, 30),
      course: Course(
        id: '1',
        courseDetails: CourseDetails(title: 'news_kurs_$id'),
        semesterId: '2',
      ),
      username: 'dozent_$id',
    ),
  );
}

MessagePreviewModel _createMessagePreviewModel({required String id}) {
  return MessagePreviewModel(
    message: Message(
      id: id,
      subject: 'subject_$id',
      message: 'message_$id',
      sender: MessageUser.withUsername(username: 'username_$id'),
      recipients: [],
      mkdate: DateTime(2023, 06, 10, 14, 30),
      isRead: false,
    ),
  );
}

CalendarPreviewModel _createCalendarPreviewModel({required String id}) {
  return CalendarPreviewModel(
    day: 10,
    locations: ['place 1'],
    entryStartDate: DateTime(2023, 06, 10, 15),
    entryTitle: 'calendarEntry_$id',
  );
}

FilePreviewModel _createFilePreviewModel({required String id}) {
  return FilePreviewModel(
    fileActivity: FileActivity(
      lastUpdatedDate: DateTime(2023, 06, 10, 14, 30),
      content: 'fileContent_$id',
      ownerFormattedName: 'ownerName_$id',
      fileName: 'filename_$id',
      course: Course(
        id: '1',
        courseDetails: CourseDetails(title: 'file_kurs_$id'),
        semesterId: '2',
      ),
    ),
  );
}
