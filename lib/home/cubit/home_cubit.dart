import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:studipadawan/home/modules/bloc/module_bloc.dart';

part 'home_state.dart';

enum ModuleType {
  messages('Nachrichten'),
  calendar('Kalender'),
  news('Ankündigungen'),
  files('Dateien');

  const ModuleType(this.title);
  final String title;
}

class HomeCubit extends HydratedCubit<HomeState> {
  HomeCubit({required this.moduleBlocs}) : super(HomeState.inital()) {
    _refreshTimer =
        Timer.periodic(const Duration(seconds: _refreshInterval), (_) {
      for (final moduleType in moduleBlocs.keys) {
        if (state.selectedModules.contains(moduleType)) {
          refreshModule(moduleType: moduleType);
        }
      }
    });

    // Initial loading
    for (final moduleType in moduleBlocs.keys) {
      // don't check for state.selectedModules.contains(moduleType) because at this point selectedModules is empty
      refreshModule(moduleType: moduleType);
    }
  }

  /// All Modules which could be displayed
  final Map<ModuleType, ModuleBloc> moduleBlocs;
  late Timer _refreshTimer;

  /// Refresh Interval in seconds
  static const _refreshInterval = 60;

  void moveModule(int oldIndex, int newIndex) {
    final modules = List.of(state.selectedModules);
    final module = modules.removeAt(oldIndex);
    modules.insert(oldIndex < newIndex ? newIndex - 1 : newIndex, module);

    emit(HomeState(selectedModules: modules));
  }

  void overrideSelectedModules({required List<ModuleType> modules}) {
    final newModules = List.of(modules);
    emit(HomeState(selectedModules: newModules));

    for (final moduleType in newModules) {
      refreshModule(moduleType: moduleType);
    }
  }

  void refreshModule({required ModuleType moduleType}) {
    moduleBlocs[moduleType]?.add(const ModuleItemsRequested());
  }

  @override
  HomeState? fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawModuleList =
        json['selectedModules'] as List<dynamic>;

    final List<ModuleType> selectedModules = rawModuleList.map((rawModuleType) {
      final String rawModuleTypeString = rawModuleType as String;
      return ModuleType.values.byName(rawModuleTypeString);
    }).toList();

    return HomeState(selectedModules: selectedModules);
  }

  @override
  Map<String, dynamic>? toJson(HomeState state) {
    return {
      'selectedModules':
          state.selectedModules.map((moduleType) => moduleType.name).toList(),
    };
  }

  @override
  Future<void> close() {
    _refreshTimer.cancel();
    for (final moduleBloc in moduleBlocs.values) {
      moduleBloc.close();
    }
    return super.close();
  }
}
