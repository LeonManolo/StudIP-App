import 'package:app_ui/app_ui.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:studipadawan/courses/details/files/bloc/course_files_bloc.dart';
import 'package:studipadawan/courses/details/files/upload_files/view/upload_files_page.dart';
import 'package:studipadawan/courses/details/files/view/widgets/course_files_items_list.dart';
import 'package:studipadawan/utils/utils.dart';

class CourseFilesContent extends StatefulWidget {
  const CourseFilesContent({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CourseFilesContentState createState() => _CourseFilesContentState();
}

class _CourseFilesContentState extends State<CourseFilesContent> {
  late TextEditingController newFolderTitleController;

  @override
  void initState() {
    super.initState();
    newFolderTitleController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    newFolderTitleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courseFilesBloc = context.read<CourseFilesBloc>();
    return BlocConsumer<CourseFilesBloc, CourseFilesState>(
      listener: (context, state) {
        if (state.type == CourseFilesStateType.error) {
          buildSnackBar(
            context,
            state.errorMessage ?? 'Es ist ein Fehler aufgetreten.',
            Colors.red,
          );
        }
      },
      builder: (context, state) {
        switch (state.type) {
          case CourseFilesStateType.didLoad || CourseFilesStateType.error:
            return Scaffold(
              body: CourseFilesItemsList(
                insertSpacerAtEnd: state.parentFolders.last.folder.isWritable ||
                    state.parentFolders.last.folder.isSubfolderAllowed,
              ),
              floatingActionButton: Visibility(
                visible: state.parentFolders.last.folder.isWritable ||
                    state.parentFolders.last.folder.isSubfolderAllowed,
                child: SpeedDial(
                  icon: EvaIcons.plus,
                  overlayColor: Colors.black,
                  overlayOpacity: 0.5,
                  spacing: AppSpacing.sm,
                  spaceBetweenChildren: AppSpacing.sm,
                  children: [
                    SpeedDialChild(
                      child: const Icon(EvaIcons.fileOutline),
                      visible: state.parentFolders.last.folder.isWritable,
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      label: 'Datei',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<UploadFilesPage>(
                            builder: (context) => UploadFilesPage(
                              parentFolderId: state.parentFolderIds.last,
                              onSuccessCallback: () => courseFilesBloc.add(
                                DidFinishFileUploadEvent(),
                              ),
                            ),
                            fullscreenDialog: true,
                          ),
                        );
                      },
                    ),
                    SpeedDialChild(
                      child: const Icon(EvaIcons.folder),
                      visible:
                          state.parentFolders.last.folder.isSubfolderAllowed,
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      label: 'Ordner',
                      onTap: () async {
                        final newFolderName =
                            await _openNewFolderDialog(context: context);
                        if (newFolderName == null) return;
                        newFolderTitleController.text =
                            ''; // delete entered text

                        courseFilesBloc.add(
                          DidFinishNewFolderCreationEvent(
                            folderName: newFolderName,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          case CourseFilesStateType.isLoading:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }

  Future<String?> _openNewFolderDialog({required BuildContext context}) {
    return showDialog<String?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Neuer Ordner'),
          content: TextField(
            decoration: const InputDecoration(
              hintText: 'Ordnername',
            ),
            controller: newFolderTitleController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Abbrechen',
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(newFolderTitleController.text);
              },
              child: const Text(
                'Erstellen',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
