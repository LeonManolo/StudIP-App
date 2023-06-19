import 'package:activity_repository/activity_repository.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/home/modules/news_module/view/widgets/news_preview_tile.dart';
import 'package:studipadawan/utils/empty_view.dart';

class NewsPreviewList extends StatelessWidget {
  const NewsPreviewList({
    super.key,
    required this.newsActivities,
  });
  final List<NewsActivity> newsActivities;

  @override
  Widget build(BuildContext context) {
    if (newsActivities.isEmpty) {
      return const Center(
        child: EmptyView(
          title: 'Keine neuen Ankündigungen',
          message: 'Es wurden keine neuen Ankündigungen veröffentlicht',
        ),
      );
    }
    return SingleChildScrollView(
      child: Column(
        children: newsActivities.asMap().entries.map((news) {
          final index = news.key;
          final newsActivity = news.value;
          final isLastNews = index == newsActivities.length - 1;

          return Column(
            children: [
              NewsPreviewTile(newsActivity: newsActivity),
              if (!isLastNews) const Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }
}
