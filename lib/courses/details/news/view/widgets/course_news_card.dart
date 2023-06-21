import 'package:app_ui/app_ui.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/utils/user_title_content_view.dart';

class CourseNewsCard extends StatelessWidget {
  const CourseNewsCard({super.key, required this.news});

  final CourseNews news;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: context.adaptiveSecondaryBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withAlpha(12),
            blurRadius: 5,
            spreadRadius: 5,
            offset: const Offset(2, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
        ),
        child: UserTitleContentView(
          userAvatarUrl: news.author.avatarUrl,
          userFormattedName: news.author.formattedName,
          userAction: UserTitleContentAction.created,
          formattedPublicationDate: news.formattedPublicationDate,
          title: news.title,
          content: news.content,
        ),
      ),
    );
  }
}
