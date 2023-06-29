import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/home/models/preview_model.dart';
import 'package:studipadawan/home/modules/bloc/module_bloc.dart';
import 'package:studipadawan/utils/empty_view.dart';
import 'package:studipadawan/utils/widgets/error_view/error_view.dart';

class ModuleCardView<Model extends PreviewModel> extends StatelessWidget {
  const ModuleCardView({super.key, required this.listTile});

  final Widget Function(PreviewModel) listTile;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ModuleBloc, ModuleState>(
      builder: (context, state) {
        switch (state) {
          case final ModuleLoaded moduleLoaded:
            if (moduleLoaded.previewModels.isEmpty) {
              return Center(
                child: EmptyView(
                  message: context.read<ModuleBloc>().emptyViewMessage,
                ),
              );
            }
            return SingleChildScrollView(
              child: Column(
                children:
                    moduleLoaded.previewModels.asMap().entries.map((item) {
                  final index = item.key;
                  final previewModel = item.value;
                  final isLastItem =
                      index == moduleLoaded.previewModels.length - 1;

                  return Column(
                    children: [
                      listTile(previewModel),
                      if (!isLastItem) const Divider(),
                    ],
                  );
                }).toList(),
              ),
            );

          case final ModuleError moduleError:
            return ErrorView(
              message: moduleError.errorMessage,
              iconData: null,
            );
        }
      },
    );
  }
}
