import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/home/bloc/home_bloc.dart';
import 'package:studipadawan/home/modules/module.dart';
import 'package:studipadawan/home/utils/module_provider.dart';

class ModuleSelectionButton extends StatelessWidget {
  const ModuleSelectionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, List<Module>>(
      bloc: context.read<HomeBloc>(),
      builder: (context, modules) {
        return PopupMenuButton<ModuleType>(
          icon: Icon(
            EvaIcons.menu2Outline,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
          onSelected: (type) =>
              context.read<HomeBloc>().addModule(getModule(type)),
          itemBuilder: (context) => ModuleType.values
              .where(
            (type) => !modules.map((module) => module.getType()).contains(type),
          )
              .map((moduleType) {
            return PopupMenuItem<ModuleType>(
              value: moduleType,
              child: Text(moduleType.title),
            );
          }).toList(),
        );
      },
    );
  }
}
