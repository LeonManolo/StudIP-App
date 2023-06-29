import 'package:flutter/material.dart';
import 'package:studipadawan/courses/details/news/view/course_news_page.dart';
import 'package:studipadawan/home/modules/news_module/model/news_preview_model.dart';

class NewsPreviewTile extends StatelessWidget {
  const NewsPreviewTile({super.key, required this.newsPreviewModel});
  final NewsPreviewModel newsPreviewModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(newsPreviewModel.title),
      subtitle: Text(newsPreviewModel.subtitle),
      leading: Icon(newsPreviewModel.iconData),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<CourseNewsPage>(
            builder: (context) => CourseNewsPage(
              courseId: newsPreviewModel.newsActivity.course.id,
            ),
            fullscreenDialog: true,
          ),
        );
      },
    );
  }
}
