import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/home/cubit/home_cubit.dart';

class ModuleSelectionModal extends StatefulWidget {
  const ModuleSelectionModal({
    super.key,
    required this.selectedModules,
    required this.onSavePressed,
  });
  final List<ModuleType> selectedModules;
  final void Function(List<ModuleType>) onSavePressed;

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
    selectedModules = widget.selectedModules;
  }

  final List<ModuleType> types = ModuleType.values;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Modulauswahl',
        ),
        actions: [
          IconButton(
            onPressed: () {
              widget.onSavePressed(selectedModules);
              Navigator.pop(context);
            },
            icon: const Icon(EvaIcons.checkmark),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: ModuleType.values.length,
        itemBuilder: (context, index) {
          final bool isLightMode =
              Theme.of(context).brightness == Brightness.light;
          final currentType = ModuleType.values.elementAt(index);

          return CheckboxListTile(
            checkColor: isLightMode ? Colors.white : Colors.black,
            fillColor: MaterialStateProperty.resolveWith(getColor),
            title: Text(currentType.title),
            value: selectedModules.contains(currentType),
            onChanged: (newValue) {
              setState(() {
                if (selectedModules.contains(currentType)) {
                  selectedModules.remove(currentType);
                } else {
                  selectedModules.add(currentType);
                }
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          );
        },
      ),
    );
  }
}
