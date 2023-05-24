import 'package:flutter/services.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:studipadawan/home/modules/module.dart';
import 'package:studipadawan/home/utils/utils.dart';

enum ModuleType {
  messages('Nachrichten'),
  calendar('Kalender'),
  news('Neuigkeiten'),
  files('Dateien');

  const ModuleType(this.title);
  final String title;
}

class HomeCubit extends HydratedCubit<List<Module>> {
  HomeCubit() : super([]);

  void reorderModules(int oldIndex, int newIndex) {
    final modules = state;
    final module = modules.removeAt(oldIndex);
    modules.insert(oldIndex < newIndex ? newIndex - 1 : newIndex, module);
    emit(List.from(modules));
  }

  void testWidgetKit() {
    WidgetKit.reloadAllTimelines();
  }

  void addModule({required Module module}) {
    final modules = state..add(module);
    emit(List.from(modules));
  }

  void overrideModules({required List<Module> modules}) {
    emit(List.from(modules));
  }

  void removeModule({required ModuleType type}) {
    final modules = state..removeWhere((module) => module.getType() == type);
    emit(List.from(modules));
  }

  @override
  List<Module>? fromJson(Map<String, dynamic> json) {
    final List<dynamic> moduleList = json['modules'] as List<dynamic>;
    return moduleList.map<Module>((moduleJson) {
      final Map<String, dynamic> json = moduleJson as Map<String, dynamic>;
      final ModuleType type = ModuleType.values.byName(json['type'].toString());
      return getModule(type);
    }).toList();
  }

  @override
  Map<String, dynamic>? toJson(List<Module> state) {
    return {
      'modules': state.map((module) => module.toJson()).toList(),
    };
  }
}
