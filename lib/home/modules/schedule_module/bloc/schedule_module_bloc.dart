import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:studipadawan/home/modules/schedule_module/bloc/schedule_module_event.dart';
import 'package:studipadawan/home/modules/schedule_module/bloc/schedule_module_state.dart';

class ScheduleModuleBloc
    extends Bloc<ScheduleModuleEvent, ScheduleModuleState> {
  ScheduleModuleBloc({
    required CalenderRepository calendarRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _calendarRepository = calendarRepository,
        _authenticationRepository = authenticationRepository,
        super(const ScheduleModuleState.initial()) {}
  final CalenderRepository _calendarRepository;
  final AuthenticationRepository _authenticationRepository;
}
