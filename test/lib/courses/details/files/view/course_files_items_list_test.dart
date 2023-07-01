import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:files_repository/files_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studipadawan/courses/details/files/bloc/course_files_bloc.dart';
import 'package:studipadawan/courses/details/files/models/file_info.dart';
import 'package:studipadawan/courses/details/files/models/folder_info.dart';
import 'package:studipadawan/courses/details/files/view/widgets/course_files_items_list.dart';
import 'package:studipadawan/courses/details/files/view/widgets/file_row/course_files_file_row.dart';
import 'package:studipadawan/utils/empty_view.dart';

class MockCourseFilesBloc extends MockBloc<CourseFilesEvent, CourseFilesState>
    implements CourseFilesBloc {}

void main() {
  late CourseFilesBloc courseFilesBloc;

  setUp(() {
    courseFilesBloc = MockCourseFilesBloc();
  });

  Future<void> setUpCourseFilesItemsList(WidgetTester tester) {
    return tester.pumpWidget(
      BlocProvider.value(
        value: courseFilesBloc,
        child: const MaterialApp(
          home: Scaffold(
            body: CourseFilesItemsList(
              insertSpacerAtEnd: false,
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('no files present - displays EmptyView', (tester) async {
    when(() => courseFilesBloc.state).thenReturn(
      const CourseFilesState(
        parentFolders: [],
        items: [],
        errorMessage: '',
        type: CourseFilesStateType.didLoad,
      ),
    );

    await setUpCourseFilesItemsList(tester);
    await tester.pump();

    expect(find.byType(EmptyView), findsOneWidget);
  });

  group('files present', () {
    final parentFolders = [_generateFolderInfo(id: 1)];
    final folder = _generateFolder(id: 2);
    final fileInfo = _generateFileInfo(id: 3);

    testWidgets('displays items', (tester) async {
      when(() => courseFilesBloc.state).thenReturn(
        CourseFilesState(
          parentFolders: parentFolders,
          items: [Left(folder), Right(fileInfo)],
          errorMessage: '',
          type: CourseFilesStateType.didLoad,
        ),
      );

      await setUpCourseFilesItemsList(tester);
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ListTile, 'folderTitle_2'), findsOneWidget);
      expect(
        find.widgetWithText(CourseFilesFileRow, 'fileName_3'),
        findsOneWidget,
      );
    });

    testWidgets('tap folder row', (tester) async {
      when(() => courseFilesBloc.state).thenReturn(
        CourseFilesState(
          parentFolders: parentFolders,
          items: [Left(folder), Right(fileInfo)],
          errorMessage: '',
          type: CourseFilesStateType.didLoad,
        ),
      );

      await setUpCourseFilesItemsList(tester);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ListTile, 'folderTitle_2'));
      await tester.pumpAndSettle();

      verify(
        () => courseFilesBloc.add(
          DidSelectFolderEvent(
            selectedFolder: folder,
            parentFolders: parentFolders,
          ),
        ),
      );
    });

    testWidgets('tap file row', (tester) async {
      when(() => courseFilesBloc.state).thenReturn(
        CourseFilesState(
          parentFolders: parentFolders,
          items: [Left(folder), Right(fileInfo)],
          errorMessage: '',
          type: CourseFilesStateType.didLoad,
        ),
      );

      await setUpCourseFilesItemsList(tester);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ListTile, 'fileName_3'));
      await tester.pumpAndSettle();

      verify(
        () => courseFilesBloc.add(
          DidSelectFileEvent(selectedFileInfo: fileInfo),
        ),
      );
    });
  });
}

FolderInfo _generateFolderInfo({required int id}) {
  return FolderInfo(
    displayName: 'folderTitle_$id',
    folderType: FolderType.normal,
    folder: _generateFolder(id: id),
  );
}

Folder _generateFolder({required int id}) {
  return Folder(
    id: 'folder_$id',
    folderType: '',
    name: 'folderTitle_$id',
    createdAt: DateTime(2023),
    lastUpdatedAt: DateTime(2023),
    isVisible: true,
    isReadable: true,
    isWritable: false,
    isSubfolderAllowed: true,
  );
}

FileInfo _generateFileInfo({required int id}) {
  return FileInfo(
    fileType: FileType.remote,
    file: File(
      id: '$id',
      name: 'fileName_$id',
      description: 'description',
      numberOfDownloads: 0,
      owner: 'finn',
      createdAt: DateTime(2023),
      lastUpdatedAt: DateTime(2023),
      mimeType: 'image/png',
      isReadable: true,
      isDownloadable: true,
    ),
  );
}
