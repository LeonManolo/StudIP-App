import 'package:bloc/bloc.dart';
import 'package:studipadawan/home/bloc/home_event.dart';
import 'package:studipadawan/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc()  :
        super(const HomeState.initial());
}
