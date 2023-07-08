import 'dart:async';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_widget/home_widget.dart';
import 'package:logger/logger.dart';
import 'package:studipadawan/calendar/bloc/calendar_bloc.dart';
import 'package:studipadawan/calendar/bloc/calendar_event.dart';
import 'package:studipadawan/calendar/bloc/calendar_state.dart';
import 'package:studipadawan/calendar/view/calendar_page.dart';
import 'package:studipadawan/courses/view/courses_page.dart';
import 'package:studipadawan/home/view/home_page.dart';
import 'package:studipadawan/messages/message_overview/view/messages_page.dart';
import 'package:studipadawan/utils/home_widget_extension.dart';

class AuthenticatedPage extends StatefulWidget {
  const AuthenticatedPage({super.key});

  static Page<void> page() =>
      const MaterialPage<void>(child: AuthenticatedPage());

  @override
  State<AuthenticatedPage> createState() => _AuthenticatedPageState();
}

// Use of WidgetsBindingObserver based on https://stackoverflow.com/a/61481717
class _AuthenticatedPageState extends State<AuthenticatedPage>
    with WidgetsBindingObserver {
  int _selectedTab = 0;
  late CalendarBloc _calendarBloc;

  @override
  void initState() {
    super.initState();
    _calendarBloc = CalendarBloc(
      calendarRepository: context.read<CalenderRepository>(),
      authenticationRepository: context.read<AuthenticationRepository>(),
    )..add(
        CalendarRequested(
          day: DateTime.now(),
          layout: CalendarBodyType.list,
        ),
      );
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // reload Widget when user (re)opens app
      unawaited(_reloadWidget());
    }
  }

  Future<void> _reloadWidget() async {
    // to avoid two token refreshes at the same time
    await HomeWidget.saveWidgetData(
      HomeWidgetName.iOSIsTokenRefreshEnabled,
      false,
    );
    await HomeWidget.updateWidget(iOSName: HomeWidgetName.iOSCalendarWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkForWidgetLaunch();
    HomeWidget.widgetClicked.listen(_launchedFromWidget);
  }

  @override
  void dispose() {
    _calendarBloc.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _checkForWidgetLaunch() {
    HomeWidget.initiallyLaunchedFromHomeWidget().then(_launchedFromWidget);
  }

  void _launchedFromWidget(Uri? uri) {
    if (uri == null) return;
    Logger().d(uri);

    setState(() {
      if (mounted) {
        _calendarBloc.add(
          CalendarRequested(
            day: DateTime.now(),
            layout: CalendarBodyType.list,
          ),
        );
        _selectedTab = 3;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedTab,
        children: [
          const HomePage(),
          const CoursesPage(),
          const MessagesPage(),
          BlocProvider(
            create: (_) => _calendarBloc,
            child: CalendarPage(calendarBloc: _calendarBloc),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(EvaIcons.homeOutline),
            activeIcon: Icon(EvaIcons.home),
          ),
          BottomNavigationBarItem(
            label: 'Kurse',
            icon: Icon(EvaIcons.bookOpenOutline),
            activeIcon: Icon(EvaIcons.bookOpen),
          ),
          BottomNavigationBarItem(
            label: 'Nachrichten',
            icon: Icon(EvaIcons.emailOutline),
            activeIcon: Icon(EvaIcons.email),
          ),
          BottomNavigationBarItem(
            label: 'Kalender',
            icon: Icon(EvaIcons.calendarOutline),
            activeIcon: Icon(EvaIcons.calendar),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedTab,
        onTap: (value) {
          setState(() {
            _selectedTab = value;
          });
        },
      ),
    );
  }
}
