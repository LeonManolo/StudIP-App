import 'package:activity_repository/activity_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:studipadawan/home/modules/news_module/bloc/news_module_event.dart';
import 'package:studipadawan/home/modules/news_module/bloc/news_module_state.dart';

const int previewLimit = 4;

class NewsModuleBloc extends Bloc<NewsModuleEvent, NewsModuleState> {
  NewsModuleBloc({
    required ActivityRepository activityRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _activityRepository = activityRepository,
        _authenticationRepository = authenticationRepository,
        super(const NewsModuleStateInitial()) {
    on<NewsActivitiesRequested>(_onNewsActivitiesRequested);
  }
  final ActivityRepository _activityRepository;
  final AuthenticationRepository _authenticationRepository;

  Future<void> _onNewsActivitiesRequested(
    NewsActivitiesRequested event,
    Emitter<NewsModuleState> emit,
  ) async {
    emit(const NewsModuleStateLoading());
    try {
      final newsActivities = await _activityRepository.getNewsActivities(
        userId: _authenticationRepository.currentUser.id,
      );

      emit(
        NewsModuleStateDidLoad(
          newsActivities: _processNewsActivities(newsActivities),
        ),
      );
    } catch (e) {
      Logger().e(e);
      emit(const NewsModuleStateError());
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
