import 'package:authentication_repository/authentication_repository.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/home/bloc/home_bloc.dart';
import 'package:studipadawan/home/modules/module.dart';
import 'package:studipadawan/home/modules/module_card.dart';
import 'package:studipadawan/home/modules/schedule_module/bloc/schedule_module_bloc.dart';
import 'package:studipadawan/home/modules/schedule_module/bloc/schedule_module_state.dart';

class ScheduleModule extends StatelessWidget implements Module {
  const ScheduleModule({
    super.key,
  });

  static const type = ModuleType.schedule;

  @override
  Widget build(BuildContext context) {
    return MoudleCard(
      type: type,
      child: BlocProvider(
        create: (context) => ScheduleModuleBloc(
            authenticationRepository: context.read<AuthenticationRepository>(),
            calendarRepository: context.read<CalenderRepository>()),
        child: BlocBuilder<ScheduleModuleBloc, ScheduleModuleState>(
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
