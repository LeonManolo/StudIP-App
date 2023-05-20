import 'package:app_ui/app_ui.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/utils/user_title_content_view.dart';

class CourseWikiDetailsPage extends StatelessWidget {
  const CourseWikiDetailsPage({super.key, required this.wikiPage});

  final CourseWikiPage wikiPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wiki-Seite')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.lg),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: UserTitleContentView(
                userAvatarUrl: wikiPage.lastEditorAuthor.avatarUrl,
                userFormattedName: wikiPage.lastEditorAuthor.formattedName,
                userAction: UserTitleContentAction.edited,
                formattedPublicationDate: wikiPage.formattedLastEditedDate,
                title: wikiPage.title,
                content: wikiPage.content,
              ),
            ),
            const SizedBox(height: AppSpacing.xlg),
          ],
        ),
      ),
    );
  }
}
