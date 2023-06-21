import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:studipadawan/home/cubit/home_cubit.dart';
import 'package:studipadawan/home/modules/module.dart';
import 'package:studipadawan/home/utils/module_provider.dart';

class ModuleSelectionModal extends StatefulWidget {
  const ModuleSelectionModal({super.key, required this.homeCubit});

  final HomeCubit homeCubit;

  @override
  State<ModuleSelectionModal> createState() => _ModuleSelectionModalState();
}

class _ModuleSelectionModalState extends State<ModuleSelectionModal> {
  Color getColor(Set<MaterialState> states) {
    return Theme.of(context).primaryColor;
  }

  late List<ModuleType> selectedModules;

  @override
  void initState() {
    super.initState();
    selectedModules =
        widget.homeCubit.state.map((module) => module.getType()).toList();
  }

  final List<ModuleType> types = ModuleType.values;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        cupertino: (cupertinoContext, _) => CupertinoNavigationBarData(
          title: const Text('Module'),
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Text('Abbrechen'),
            onPressed: () => Navigator.pop(context),
          ),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: _onSavedPressed,
            child: const Text(
              'Speichern',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        material: (materialContext, _) => MaterialAppBarData(
          title: const Text('Module'),
          actions: [
            IconButton(
              onPressed: _onSavedPressed,
              icon: const Icon(EvaIcons.checkmark),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: ModuleType.values.length,
              itemBuilder: (context, index) {
                final currentType = ModuleType.values.elementAt(index);
                return Row(
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: selectedModules.contains(currentType),
                      onChanged: (bool? _) {
                        setState(() {
                          if (selectedModules.contains(currentType)) {
                            selectedModules.remove(currentType);
                          } else {
                            selectedModules.add(currentType);
                          }
                        });
                      },
                    ),
                    Text(currentType.title)
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _onSavedPressed() {
    final List<Module> modules = [];
    for (final moduleType in selectedModules) {
      modules.add(getModule(moduleType));
    }
    widget.homeCubit.overrideModules(modules: modules);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
    });
  }
}
