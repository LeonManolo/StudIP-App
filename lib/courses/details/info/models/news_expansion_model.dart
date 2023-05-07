import 'package:courses_repository/courses_repository.dart';

class NewsExpansionModel {

  NewsExpansionModel({
    required this.news,
    this.isExpanded = false,
  });
  final List<CourseNews> news;
  bool isExpanded;

  NewsExpansionModel copyWith({List<CourseNews>? news, bool? isExpanded}) {
    return NewsExpansionModel(
      news: news ?? this.news,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}
