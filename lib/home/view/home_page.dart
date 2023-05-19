import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/app/bloc/app_bloc.dart';
import 'package:studipadawan/home/cubit/home_cubit.dart';
import 'package:studipadawan/home/modules/module.dart';
import 'package:studipadawan/home/view/widgets/module_reorderable_list.dart';
import 'package:studipadawan/home/view/widgets/module_selection_modal.dart';
import 'package:studipadawan/utils/empty_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    final homeCubit = HomeCubit();

    return BlocProvider(
      create: (_) => homeCubit,
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
        body: BlocBuilder<HomeCubit, List<Module>>(
          builder: (context, modules) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: modules.isEmpty
                      ? const Center(
                          child: EmptyView(
                            title: 'Keine Widgets vorhanden',
                            message: 'Es sind keine Widgets vorhanden',
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ReorderableModuleListView(
                            modules: modules,
                          ),
                        ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showCenteredCupertinoModal(context, (BuildContext _) {
                      return ModuleSelectionModal(homeCubit: homeCubit);
                    });
                  },
                  child: const Text('Module bearbeiten'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void showCenteredCupertinoModal(BuildContext context, WidgetBuilder builder) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: builder(context),
        );
      },
    );
  }
}
