import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Modulauswahl',
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const SizedBox(height: 16),
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Abbrechen'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final List<Module> modules = [];
                      for (final moduleType in selectedModules) {
                        modules.add(getModule(moduleType));
                      }
                      widget.homeCubit.overrideModules(modules: modules);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pop(context);
                      });
                    },
                    child: const Text('Speichern'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
