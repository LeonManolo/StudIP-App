import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/home/cubit/home_cubit.dart';
import 'package:studipadawan/home/modules/calendar_module/bloc/calendar_module_bloc.dart';
import 'package:studipadawan/home/modules/calendar_module/bloc/calendar_module_event.dart';
import 'package:studipadawan/home/modules/calendar_module/bloc/calendar_module_state.dart';
import 'package:studipadawan/home/modules/calendar_module/view/widgets/calendar_preview_list.dart';
import 'package:studipadawan/home/modules/module.dart';
import 'package:studipadawan/home/modules/module_card.dart';
import 'package:studipadawan/utils/empty_view.dart';

class CalendarModule extends StatefulWidget implements Module {
  const CalendarModule({
    super.key,
  });

  static const type = ModuleType.calendar;

  @override
  ModuleType getType() {
    return CalendarModule.type;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': CalendarModule.type.name,
    };
  }

  @override
  State<CalendarModule> createState() => _CalendarModuleState();
}

class _CalendarModuleState extends State<CalendarModule> {
  late Timer _refreshTimer;
  late CalendarModuleBloc _calendarModuleBloc;
  @override
  void initState() {
    super.initState();
    _calendarModuleBloc = CalendarModuleBloc(
      calendarRepository: context.read<CalenderRepository>(),
      authenticationRepository: context.read<AuthenticationRepository>(),
    )..add(const CalendarPreviewRequested());
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      // TODO: Adjust delay
      _calendarModuleBloc.add(const CalendarPreviewRequested());
    });
  }

  @override
  void dispose() {
    super.dispose();
    _calendarModuleBloc.close();
    _refreshTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ModuleCard(
      type: CalendarModule.type,
      child: BlocProvider.value(
        value: _calendarModuleBloc,
        child: BlocBuilder<CalendarModuleBloc, CalendarModuleState>(
          builder: (context, state) {
            switch (state) {
              case CalendarModuleStateInitial _:
                return Container();
              case CalendarModuleStateLoading _:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case CalendarModuleStateDidLoad _:
                return CalendarPreviewList(
                  calendarModuleBloc: _calendarModuleBloc,
                  calendarEntries: state.calendarEntries,
                );
              case CalendarModuleStateError _:
                return const EmptyView(
                  title: 'Es ist ein Fehler aufgetreten',
                  message: 'Es konnten keine Informationen abgerufen werden',
                );
            }
          },
        ),
      ),
    );
  }
}
