import 'package:app_ui/app_ui.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class CourseNewsCard extends StatelessWidget {
  const CourseNewsCard({super.key, required this.news});

  final CourseNews news;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
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
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(
                        news.author.avatarUrl,
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'Von ',
                          children: [
                            TextSpan(
                              text: news.author.formattedName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              children: const [
                                TextSpan(
                                  text: ' erstellt',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        news.formattedPublicationDate,
                        style: const TextStyle(color: Colors.black54),
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              news.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            HtmlWidget(news.content)
          ],
        ),
      ),
    );
  }
}
