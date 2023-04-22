import 'package:courses_repository/courses_repository.dart';

class NewsExpansionModel {
  final List<CourseNews> news;
  bool isExpanded;

  NewsExpansionModel({
    required this.news,
    this.isExpanded = false,
  });

  NewsExpansionModel copyWith({List<CourseNews>? news, bool? isExpanded}) {
    return NewsExpansionModel(
      news: news ?? this.news,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}
