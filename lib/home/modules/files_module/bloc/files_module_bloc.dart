import 'package:activity_repository/activity_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:studipadawan/home/modules/bloc/module_bloc.dart';
import 'package:studipadawan/home/modules/files_module/model/file_preview_model.dart';

class FilesModuleBloc extends ModuleBloc {
  FilesModuleBloc({
    required ActivityRepository activityRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _activityRepository = activityRepository,
        _authenticationRepository = authenticationRepository,
        super();

  final ActivityRepository _activityRepository;
  final AuthenticationRepository _authenticationRepository;

  @override
  String get emptyViewMessage => 'Keine aktuellen Dateien vorhanden.';

  @override
  Future<void> onModuleItemsRequested(
    ModuleItemsRequested event,
    Emitter<ModuleState> emit,
  ) async {
    try {
      final fileActivities = await _activityRepository.getFileActivities(
        userId: _authenticationRepository.currentUser.id,
        limit: previewLimit,
      );

      emit(
        ModuleLoaded(
          previewModels: fileActivities
              .map(
                (fileActivity) => FilePreviewModel(fileActivity: fileActivity),
              )
              .toList(),
        ),
      );
    } catch (e) {
      Logger().e(e);
      emit(
        const ModuleError(
          errorMessage: 'Beim Laden der Dateien ist ein Fehler aufgetreten.',
        ),
      );
    }
  }
}
