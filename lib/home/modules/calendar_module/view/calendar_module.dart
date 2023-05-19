import 'package:authentication_repository/authentication_repository.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/home/cubit/home_cubit.dart';
import 'package:studipadawan/home/modules/calendar_module/bloc/calendar_module_bloc.dart';
import 'package:studipadawan/home/modules/calendar_module/bloc/calendar_module_state.dart';
import 'package:studipadawan/home/modules/module.dart';
import 'package:studipadawan/home/modules/module_card.dart';

class CalendarModule extends StatelessWidget implements Module {
  const CalendarModule({
    super.key,
  });

  static const type = ModuleType.calendar;

  @override
  Widget build(BuildContext context) {
    return MoudleCard(
      type: type,
      child: BlocProvider(
        create: (context) => CalendarModuleBloc(
          authenticationRepository: context.read<AuthenticationRepository>(),
          calendarRepository: context.read<CalenderRepository>(),
        ),
        child: BlocBuilder<CalendarModuleBloc, CalendarModuleState>(
          builder: (context, state) {
            return const Text('Content');
          },
        ),
      ),
    );
  }

  @override
  ModuleType getType() {
    return type;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
    };
  }
}
