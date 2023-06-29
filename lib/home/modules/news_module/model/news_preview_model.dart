import 'package:activity_repository/activity_repository.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:studipadawan/home/models/preview_model.dart';

class NewsPreviewModel implements PreviewModel {
  NewsPreviewModel({required this.newsActivity});

  final NewsActivity newsActivity;

  @override
  IconData get iconData => EvaIcons.infoOutline;

  @override
  String get subtitle =>
      'In ${newsActivity.course.courseDetails.title} ${newsActivity.getTimeAgo()}';

  @override
  String get title => newsActivity.title;
}
