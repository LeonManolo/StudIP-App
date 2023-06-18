import 'package:activity_repository/activity_repository.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/courses/details/news/view/course_news_page.dart';

class NewsPreviewTile extends StatelessWidget {
  const NewsPreviewTile({super.key, required this.newsActivity});
  final NewsActivity newsActivity;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Kurs: ${newsActivity.course?.courseDetails.title}'),
      subtitle: Text('Von: ${newsActivity.userName}'),
      leading: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Icon(EvaIcons.infoOutline)],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(newsActivity.getTimeAgo()),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<CourseNewsPage>(
            builder: (context) => CourseNewsPage(
              courseId: newsActivity.course!.id,
            ),
            fullscreenDialog: true,
          ),
        );
      },
    );
  }
}
