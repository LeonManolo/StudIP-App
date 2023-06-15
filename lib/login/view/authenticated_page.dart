import 'dart:io';

import 'package:app_ui/app_ui.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:studipadawan/calendar/view/calendar_page.dart';
import 'package:studipadawan/courses/view/courses_page.dart';
import 'package:studipadawan/home/view/home_page.dart';

import 'package:studipadawan/messages/message_overview/view/messages_page.dart';

class AuthenticatedPage extends StatelessWidget {
  const AuthenticatedPage({super.key});

  static Page<void> page() =>
      const MaterialPage<void>(child: AuthenticatedPage());

  List<Widget> get tabPages => const [
    HomePage(),
    CoursesPage(),
    MessagesPage(),
    CalendarPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return AdaptiveTabScaffold(
      tabs: tabPages,
      items: [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Platform.isIOS ? CupertinoIcons.house : EvaIcons.homeOutline),
          activeIcon: Icon(Platform.isIOS ? CupertinoIcons.house_fill : EvaIcons.home),
        ),
        BottomNavigationBarItem(
          label: 'Kurse',
          icon: Icon(Platform.isIOS ? CupertinoIcons.rectangle_stack : EvaIcons.bookOpenOutline),
          activeIcon: Icon(Platform.isIOS ? CupertinoIcons.rectangle_stack_fill : EvaIcons.bookOpen),
        ),
        BottomNavigationBarItem(
          label: 'Nachrichten',
          icon: Icon(Platform.isIOS ? CupertinoIcons.mail : EvaIcons.emailOutline),
          activeIcon: Icon(Platform.isIOS ? CupertinoIcons.mail_solid : EvaIcons.email),
        ),
        BottomNavigationBarItem(
          label: 'Kalender',
          icon: Icon(Platform.isIOS ? CupertinoIcons.calendar : EvaIcons.calendarOutline),
          activeIcon: Icon(Platform.isIOS ? CupertinoIcons.calendar : EvaIcons.calendar),
        ),
      ],
    );
  }
}

