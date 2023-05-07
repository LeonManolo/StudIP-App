import 'package:files_repository/files_repository.dart';
import 'package:flutter/material.dart';

class CourseFilesFileInfoAlert extends StatelessWidget {
  const CourseFilesFileInfoAlert({super.key, required this.file});
  final File file;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(file.name),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            if (file.description.isEmpty)
              const SizedBox(
                height: 0,
              )
            else
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Beschreibung'),
                subtitle: Text(file.description),
              ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Autor'),
              subtitle: Text(file.owner),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Downloads'),
              subtitle: Text('${file.numberOfDownloads}'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Erstellt'),
              subtitle: Text(file.createdAtFormatted),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Letzte Aktualisierung'),
              subtitle: Text(file.lastUpdatedAtFormatted),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Ok'),
        )
      ],
    );
  }
}
