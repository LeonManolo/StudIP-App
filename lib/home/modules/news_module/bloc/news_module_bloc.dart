import 'package:activity_repository/activity_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
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
          on<NewsActivitiesRequested>(_onFileActivitiesRequested);
        }
  final ActivityRepository _activityRepository;
  final AuthenticationRepository _authenticationRepository;

  Future<void> _onFileActivitiesRequested(
    NewsActivitiesRequested event,
    Emitter<NewsModuleState> emit,
  ) async {
    emit(const NewsModuleStateLoading());
    try {
      final newsActivities = await _activityRepository.getNewsActivities(
        userId: _authenticationRepository.currentUser.id,
        limit: previewLimit,
      );

      emit(
        NewsModuleStateDidLoad(
          newsActivities: newsActivities,
        ),
      );
    } catch (e) {
      emit(const NewsModuleStateError());
    }
  }
}
