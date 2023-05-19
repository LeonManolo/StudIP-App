import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/home/cubit/home_cubit.dart';
import 'package:studipadawan/home/modules/module.dart';
import 'package:studipadawan/home/modules/module_card.dart';
import 'package:studipadawan/home/modules/news_module/bloc/news_module_bloc.dart';
import 'package:studipadawan/home/modules/news_module/bloc/news_module_state.dart';

class NewsModule extends StatelessWidget implements Module {
  const NewsModule({
    super.key,
  });

  static const type = ModuleType.news;

  @override
  Widget build(BuildContext context) {
    return MoudleCard(
      type: type,
      child: BlocProvider(
        create: (context) => NewsModuleBloc(
          courseRepository: context.read<CourseRepository>(),
        ),
        child: BlocBuilder<NewsModuleBloc, NewsModuleState>(
          builder: (context, state) {
            return const Text('Content');
          },
        ),
      ),
    );
  }

  @override
  ModuleType getType() {
    return type;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
    };
  }
}
