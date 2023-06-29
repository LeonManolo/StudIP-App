import 'package:activity_repository/activity_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:studipadawan/home/modules/bloc/module_bloc.dart';
import 'package:studipadawan/home/modules/news_module/model/news_preview_model.dart';

class NewsModuleBloc extends ModuleBloc {
  NewsModuleBloc({
    required ActivityRepository activityRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _activityRepository = activityRepository,
        _authenticationRepository = authenticationRepository,
        super();

  final ActivityRepository _activityRepository;
  final AuthenticationRepository _authenticationRepository;

  @override
  String get emptyViewMessage => 'Keine aktuellen Ankündigungen vorhanden';

  @override
  Future<void> onModuleItemsRequested(
    ModuleItemsRequested event,
    Emitter<ModuleState> emit,
  ) async {
    try {
      final rawNewsActivities = await _activityRepository.getNewsActivities(
        userId: _authenticationRepository.currentUser.id,
      );
      final newsAcitvities = _processNewsActivities(rawNewsActivities);
      emit(
        ModuleLoaded(
          previewModels: newsAcitvities
              .map(
                (newsActivity) => NewsPreviewModel(newsActivity: newsActivity),
              )
              .toList(),
        ),
      );
    } catch (e) {
      Logger().e(e);
      emit(
        const ModuleError(
          errorMessage:
              'Beim Laden der Ankündigungen ist ein Fehler aufgetreten.',
        ),
      );
    }
  }

  List<NewsActivity> _processNewsActivities(List<NewsActivity> newsActivities) {
    return newsActivities
        .where(
          (newsActivity) => newsActivity.publicationEnd.isAfter(DateTime.now()),
        )
        .toList()
      ..sort((a, b) => b.publicationEnd.compareTo(a.publicationEnd))
      ..take(previewLimit);
  }
}
