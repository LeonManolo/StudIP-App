import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:studipadawan/home/models/preview_model.dart';

part 'module_event.dart';
part 'module_state.dart';

abstract class ModuleBloc extends Bloc<ModuleEvent, ModuleState> {
  ModuleBloc() : super(ModuleLoaded.initial()) {
    on<ModuleItemsRequested>(onModuleItemsRequested);
  }

  final int previewLimit = 3;

  abstract final String emptyViewMessage;

  Future<void> onModuleItemsRequested(
    ModuleItemsRequested event,
    Emitter<ModuleState> emit,
  );
}
