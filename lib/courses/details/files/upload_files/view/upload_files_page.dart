import 'package:app_ui/app_ui.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:files_repository/files_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:studipadawan/courses/details/files/upload_files/bloc/upload_files_bloc.dart';
import 'package:studipadawan/courses/details/files/upload_files/model/upload_file_model.dart';
import 'package:studipadawan/utils/utils.dart';

class UploadFilesPage extends StatelessWidget {
  const UploadFilesPage({
    super.key,
    required this.parentFolderId,
    required this.onSuccessCallback,
  });

  final String parentFolderId;
  final void Function() onSuccessCallback;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hochladen')),
      body: SafeArea(
        child: BlocProvider<UploadFilesBloc>(
          create: (context) => UploadFilesBloc(
            filesRepository: context.read<FilesRepository>(),
            parentFolderId: parentFolderId,
            onSuccessCallback: onSuccessCallback,
          ),
          child: BlocConsumer<UploadFilesBloc, UploadFilesState>(
            listener: (context, state) {
              if (state.type == UploadFileStateType.failure) {
                buildSnackBar(
                  context,
                  state.failureMessage ??
                      'Ein unbekannter Fehler ist aufgetreten',
                  Colors.red,
                );
              } else if (state.type == UploadFileStateType.success) {
                Navigator.of(context).pop();
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  Expanded(
                    child: state.type == UploadFileStateType.empty
                        ? const Center(child: Text('Keine Dateien ausgewählt'))
                        : ListView.builder(
                            itemBuilder: (context, index) {
                              final UploadFileModel uploadFileModel =
                                  state.filesToUpload.elementAt(index);
                              return ListTile(
                                title: Text(uploadFileModel.fileName),
                                leading: const Icon(EvaIcons.fileOutline),
                                trailing: IconButton(
                                  icon: const Icon(
                                    EvaIcons.trash2Outline,
                                    color: Colors.red,
                                  ),
                                  onPressed: () =>
                                      context.read<UploadFilesBloc>().add(
                                            DeletePickedFileEvent(
                                              selectedIndex: index,
                                            ),
                                          ),
                                ),
                                onTap: () =>
                                    context.read<UploadFilesBloc>().add(
                                          DidSelectPickedFileEvent(
                                            localFilePath:
                                                uploadFileModel.localFilePath,
                                          ),
                                        ),
                              );
                            },
                            itemCount: state.filesToUpload.length,
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<UploadFilesBloc>()
                                .add(DidSelectAddFilesEvent());
                          },
                          child: Row(
                            children: const [
                              Spacer(),
                              Text('Dateien hinzufügen'),
                              Spacer()
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        ElevatedButton(
                          onPressed: state.type == UploadFileStateType.empty ||
                                  state.type == UploadFileStateType.loading
                              ? null
                              : () {
                                  context.read<UploadFilesBloc>().add(
                                        DidSelectUploadFilesEvent(
                                          localFilePaths: state.filesToUpload
                                              .map(
                                                (uploadFileModel) =>
                                                    uploadFileModel
                                                        .localFilePath,
                                              )
                                              .toList(),
                                        ),
                                      );
                                },
                          child: Row(
                            children: state.type == UploadFileStateType.loading
                                ? [
                                    const Spacer(),
                                    SpinKitThreeBounce(
                                      size: 20,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const Spacer()
                                  ]
                                : const [Spacer(), Text('Hochladen'), Spacer()],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
