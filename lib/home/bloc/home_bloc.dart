import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:studipadawan/home/modules/module.dart';
import 'package:studipadawan/home/utils/utils.dart';

enum ModuleType {
  messages('Nachrichten'),
  schedule('Termine'),
  news('Neuigkeiten'),
  files('Dateien');

  const ModuleType(this.title);
  final String title;
}

class HomeBloc extends HydratedCubit<List<Module>> {
  HomeBloc() : super([]);
  void reorderModules(int oldIndex, int newIndex) {
    final modules = state;
    final module = modules.removeAt(oldIndex);
    modules.insert(oldIndex < newIndex ? newIndex - 1 : newIndex, module);
    emit(List.from(modules));
  }

  void addModule(Module module) {
    final modules = state..add(module);
    emit(List.from(modules));
  }

  void removeModule(ModuleType type) {
    final modules = state..removeWhere((module) => module.getType() == type);
    emit(List.from(modules));
  }

  @override
  List<Module>? fromJson(Map<String, dynamic> json) {
    final List<dynamic> moduleList = json['modules'] as List<dynamic>;
    final modules = moduleList.map<Module>((moduleJson) {
      final Map<String, dynamic> json = moduleJson as Map<String, dynamic>;
      final ModuleType type = ModuleType.values.firstWhere(
        (ModuleType value) => value.name == json['type'].toString(),
        orElse: () => throw Exception('Unbekannter Modultyp: ${json['type']}'),
      );
      return getModule(type);
    }).toList();
    return modules;
  }

  @override
  Map<String, dynamic>? toJson(List<Module> state) {
    return {
      'modules': state.map((module) => module.toJson()).toList(),
    };
  }
}
