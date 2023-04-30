import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';

class CourseFilesFileInfoAlert extends StatelessWidget {
  final File file;
  const CourseFilesFileInfoAlert({Key? key, required this.file})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(file.name),
      content: SingleChildScrollView(
          child: ListBody(
        children: [
          file.description.isEmpty
              ? const SizedBox(
                  height: 0,
                )
              : ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text("Beschreibung"),
                  subtitle: Text(file.description),
                ),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: const Text("Autor"),
            subtitle: Text(file.owner),
          ),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: const Text("Downloads"),
            subtitle: Text("${file.numberOfDownloads}"),
          ),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: const Text("Erstellt"),
            subtitle: Text(file.createdAtFormatted),
          ),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: const Text("Letzte Aktualisierung"),
            subtitle: Text(file.lastUpdatedAtFormatted),
          ),
        ],
      )),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Ok"),
        )
      ],
    );
  }
}
