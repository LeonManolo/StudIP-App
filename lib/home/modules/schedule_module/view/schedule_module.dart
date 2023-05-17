import 'package:authentication_repository/authentication_repository.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/home/modules/module_card.dart';
import 'package:studipadawan/home/modules/schedule_module/bloc/schedule_module_bloc.dart';
import 'package:studipadawan/home/modules/schedule_module/bloc/schedule_module_state.dart';

class ScheduleModule extends StatelessWidget {
  const ScheduleModule({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MoudleCard(
      headline: 'Termine',
      module: BlocProvider(
        create: (context) => ScheduleModuleBloc(
          calendarRepository: context.read<CalenderRepository>(),
          authenticationRepository: context.read<AuthenticationRepository>(),
        ),
        child: BlocBuilder<ScheduleModuleBloc, ScheduleModuleState>(
          builder: (context, state) {
            return const Text('Moin');
          },
        ),
      ),
    );
  }
}
