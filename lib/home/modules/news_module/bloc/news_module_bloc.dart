import 'package:bloc/bloc.dart';
import 'package:courses_repository/courses_repository.dart';
import 'package:studipadawan/home/modules/news_module/bloc/news_module_event.dart';
import 'package:studipadawan/home/modules/news_module/bloc/news_module_state.dart';

class NewsModuleBloc extends Bloc<NewsModuleEvent, NewsModuleState> {
  NewsModuleBloc({
    required CourseRepository courseRepository,
  })  : _courseRepository = courseRepository,
        super(const NewsModuleStateInitial());
  final CourseRepository _courseRepository;
}
