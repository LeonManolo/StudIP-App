import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:studipadawan/home/modules/calendar_module/bloc/calendar_module_event.dart';
import 'package:studipadawan/home/modules/calendar_module/bloc/calendar_module_state.dart';

class CalendarModuleBloc
    extends Bloc<CalendarModuleEvent, CalendarModuleState> {
  CalendarModuleBloc({
    required CalenderRepository calendarRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _calendarRepository = calendarRepository,
        _authenticationRepository = authenticationRepository,
        super(const CalendarModuleStateInitial());
  final CalenderRepository _calendarRepository;
  final AuthenticationRepository _authenticationRepository;
}
