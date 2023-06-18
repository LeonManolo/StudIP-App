import 'dart:async';

import 'package:activity_repository/activity_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/home/cubit/home_cubit.dart';
import 'package:studipadawan/home/modules/files_module/bloc/files_module_bloc.dart';
import 'package:studipadawan/home/modules/files_module/bloc/files_module_event.dart';
import 'package:studipadawan/home/modules/files_module/bloc/files_module_state.dart';
import 'package:studipadawan/home/modules/files_module/view/widgets/files_preview_list.dart';
import 'package:studipadawan/home/modules/module.dart';
import 'package:studipadawan/home/modules/module_card.dart';
import 'package:studipadawan/home/modules/news_module/bloc/news_module_bloc.dart';
import 'package:studipadawan/home/modules/news_module/bloc/news_module_event.dart';
import 'package:studipadawan/home/modules/news_module/bloc/news_module_state.dart';
import 'package:studipadawan/home/modules/news_module/view/widgets/news_preview_list.dart';
import 'package:studipadawan/utils/empty_view.dart';

class NewsModule extends StatefulWidget implements Module {
  const NewsModule({
    super.key,
  });

  static const type = ModuleType.news;

  @override
  ModuleType getType() {
    return NewsModule.type;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': NewsModule.type.name,
    };
  }

  @override
  State<NewsModule> createState() => _NewsModuleState();
}

class _NewsModuleState extends State<NewsModule> {
  late Timer _refreshTimer;
  late NewsModuleBloc _newsModuleBloc;
  @override
  void initState() {
    super.initState();
    _newsModuleBloc = NewsModuleBloc(
      activityRepository: context.read<ActivityRepository>(),
      authenticationRepository: context.read<AuthenticationRepository>(),
    )..add(const NewsActivitiesRequested());
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      // TODO: Adjust delay
      _newsModuleBloc.add(const NewsActivitiesRequested());
    });
  }

  @override
  void dispose() {
    super.dispose();
    _newsModuleBloc.close();
    _refreshTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ModuleCard(
      type: NewsModule.type,
      child: BlocProvider.value(
        value: _newsModuleBloc,
        child: BlocBuilder<NewsModuleBloc, NewsModuleState>(
          builder: (context, state) {
            switch (state) {
              case NewsModuleStateInitial _:
                return Container();
              case NewsModuleStateLoading _:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case NewsModuleStateDidLoad _:
                return NewspreviewList(
                  newsActivities: state.newsActivities,
                );
              case NewsModuleStateError _:
                return const EmptyView(
                  title: 'Es ist ein Fehler aufgetreten',
                  message: 'Es konnten keine Informationen abgerufen werden',
                );
            }
          },
        ),
      ),
    );
  }
}
