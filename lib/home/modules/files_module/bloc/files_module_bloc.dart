import 'package:activity_repository/activity_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:studipadawan/home/modules/files_module/bloc/files_module_event.dart';
import 'package:studipadawan/home/modules/files_module/bloc/files_module_state.dart';

const int previewLimit = 4;

class FilesModuleBloc extends Bloc<FilesModuleEvent, FilesModuleState> {
  FilesModuleBloc({
    required ActivityRepository activityRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _activityRepository = activityRepository,
        _authenticationRepository = authenticationRepository,
        super(const FilesModuleStateInitial()) {
    on<FileActivitiesRequested>(_onFileActivitiesRequested);
  }
  final ActivityRepository _activityRepository;
  final AuthenticationRepository _authenticationRepository;

  Future<void> _onFileActivitiesRequested(
    FileActivitiesRequested event,
    Emitter<FilesModuleState> emit,
  ) async {
    emit(const FilesModuleStateLoading());
    try {
      final fileActivities = await _activityRepository.getFileActivities(
        userId: _authenticationRepository.currentUser.id,
        limit: previewLimit,
      );

      emit(
        FilesModuleStateDidLoad(
          fileActivities: fileActivities,
        ),
      );
    } catch (e) {
      emit(const FilesModuleStateError());
    }
  }
}
