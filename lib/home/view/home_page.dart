import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
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
      child: PlatformScaffold(
        appBar: PlatformAppBar(
          title: const Text('Home'),
          trailingActions: <Widget>[
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
            return ListView(
              children: [
                SizedBox(height: 400,),
                if (modules.isEmpty) const Center(
                        child: EmptyView(
                          title: 'Keine Module vorhanden',
                          message: 'Es sind keine Module vorhanden',
                        ),
                      ) else Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ReorderableModuleListView(
                          modules: modules,
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
                Image.network("https://imageproxy.wolt.com/venue/60d995ef9f5d9a22b6f99a86/dbbc59fe-da56-11eb-b04c-322545135063_food_brothers_close_up_2.jpg"),
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
