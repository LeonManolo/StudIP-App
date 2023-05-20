
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/home/cubit/home_cubit.dart';
import 'package:studipadawan/home/modules/module.dart';
import 'package:studipadawan/home/modules/module_card.dart';

const double bottomPadding = 16;

class ReorderableModuleListView extends StatelessWidget {
  const ReorderableModuleListView({super.key, required this.modules});
  final List<Module> modules;

  @override
  Widget build(BuildContext context) {
    Widget proxyDecorator(
      Widget child,
      int index,
      Animation<double> animation,
    ) {
      return Material(
        color: Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(radius)),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: bottomPadding,
              child: Material(
                color: Theme.of(context).primaryColor.withOpacity(0.6),
                borderRadius: const BorderRadius.all(Radius.circular(radius)),
                shadowColor: Theme.of(context).shadowColor.withOpacity(0.15),
              ),
            ),
            child,
          ],
        ),
      );
    }

    return ReorderableListView(
      onReorder: (oldIndex, newIndex) {
        context.read<HomeCubit>().reorderModules(oldIndex, newIndex);
      },
      proxyDecorator: proxyDecorator,
      children: modules.map((module) {
        return DecoratedBox(
          key: Key(module.getType().name),
          decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(radius)),
            ),
            child: Column(
              children: [
                module,
                const Opacity(
                  opacity: 0,
                  child: SizedBox(height: bottomPadding),
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
