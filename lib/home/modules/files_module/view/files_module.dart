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
import 'package:studipadawan/utils/empty_view.dart';

class FilesModule extends StatefulWidget implements Module {
  const FilesModule({
    super.key,
  });

  static const type = ModuleType.files;

  @override
  ModuleType getType() {
    return FilesModule.type;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': FilesModule.type.name,
    };
  }

  @override
  State<FilesModule> createState() => _FilesModuleState();
}

class _FilesModuleState extends State<FilesModule> {
  late Timer _refreshTimer;
  late FilesModuleBloc _filesModuleBloc;
  @override
  void initState() {
    super.initState();
    _filesModuleBloc = FilesModuleBloc(
      activityRepository: context.read<ActivityRepository>(),
      authenticationRepository: context.read<AuthenticationRepository>(),
    )..add(const FileActivitiesRequested());
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) { // TODO: Adjust delay
      _filesModuleBloc.add(const FileActivitiesRequested());
    });
  }

  @override
  void dispose() {
    super.dispose();
    _filesModuleBloc.close();
    _refreshTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ModuleCard(
      type: FilesModule.type,
      child: BlocProvider.value(
        value: _filesModuleBloc,
        child: BlocBuilder<FilesModuleBloc, FilesModuleState>(
          builder: (context, state) {
            switch (state) {
              case FilesModuleStateInitial _:
                return Container();
              case FilesModuleStateLoading _:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case FilesModuleStateDidLoad _:
                return FilespreviewList(
                  fileActivities: state.fileActivities,
                );
              case FilesModuleStateError _:
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
