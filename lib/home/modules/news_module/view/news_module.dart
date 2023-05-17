import 'package:courses_repository/courses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/home/modules/module_card.dart';
import 'package:studipadawan/home/modules/news_module/bloc/news_module_bloc.dart';
import 'package:studipadawan/home/modules/news_module/bloc/news_module_state.dart';

class NewsModule extends StatelessWidget {
  const NewsModule({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MoudleCard(
      headline: 'Neuigkeiten',
      module: BlocProvider(
        create: (context) => NewsModuleBloc(
          courseRepository: context.read<CourseRepository>(),
        ),
        child: BlocBuilder<NewsModuleBloc, NewsModuleState>(
          builder: (context, state) {
            return const Text('Moin');
          },
        ),
      ),
    );
  }
}
