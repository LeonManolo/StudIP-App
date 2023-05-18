import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/app/bloc/app_bloc.dart';
import 'package:studipadawan/home/bloc/home_bloc.dart';
import 'package:studipadawan/home/modules/module.dart';
import 'package:studipadawan/home/view/widgets/module_selection_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    final homeBloc = HomeBloc();

    return BlocProvider(
      create: (_) => homeBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: <Widget>[
            IconButton(
              key: const Key('homePage_logout_iconButton'),
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                context.read<AppBloc>().add(const AppLogoutRequested());
              },
            )
          ],
        ),
        body: BlocBuilder<HomeBloc, List<Module>>(
          builder: (context, modules) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(child: Container()),
                    const ModuleSelectionButton()
                  ],
                ),
                Expanded(
                  child: ReorderableListView(
                    onReorder: (oldIndex, newIndex) {
                      context
                          .read<HomeBloc>()
                          .reorderModules(oldIndex, newIndex);
                    },
                    children: modules.map((module) {
                      return Container(
                        key: Key(
                          module.getType().name,
                        ),
                        child: module,
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
