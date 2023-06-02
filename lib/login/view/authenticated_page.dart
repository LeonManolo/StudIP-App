import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:studipadawan/calendar/view/calendar_page.dart';
import 'package:studipadawan/courses/view/courses_page.dart';
import 'package:studipadawan/home/view/home_page.dart';

import 'package:studipadawan/messages/message_overview/view/messages_page.dart';

class AuthenticatedPage extends StatefulWidget {
  const AuthenticatedPage({super.key});

  static Page<void> page() =>
      const MaterialPage<void>(child: AuthenticatedPage());

  @override
  State<AuthenticatedPage> createState() => _AuthenticatedPageState();
}

class _AuthenticatedPageState extends State<AuthenticatedPage> {
  int _selectedTab = 0;
  final List<Widget> tabPages = const [
    HomePage(),
    CoursesPage(),
    MessagesPage(),
    CalendarPage(),
  ];

  late PlatformTabController tabController;

  @override
  void initState() {
    super.initState();

    // If you want further control of the tabs have one of these
    tabController = PlatformTabController(
      initialIndex: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformTabScaffold(
      iosContentPadding: true,
      iosContentBottomPadding: true,
      tabController: tabController,
      material: (context, index) => MaterialTabScaffoldData(
        bodyBuilder: (_, __) => IndexedStack(
          index: _selectedTab,
          children: tabPages,
        ),
      ),
      cupertino: (_,__) => CupertinoTabScaffoldData(
        bodyBuilder: (context, index) => tabPages[index],
      ),

      items: [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Platform.isIOS ? CupertinoIcons.house : EvaIcons.homeOutline),
          activeIcon: Icon(Platform.isIOS ? CupertinoIcons.house_fill : EvaIcons.home),
        ),
        BottomNavigationBarItem(
          label: 'Kurse',
          icon: Icon(Platform.isIOS ? CupertinoIcons.rectangle_stack : EvaIcons.calendarOutline),
          activeIcon: Icon(Platform.isIOS ? CupertinoIcons.rectangle_stack_fill : EvaIcons.calendarOutline),
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
      //type: BottomNavigationBarType.fixed,
      itemChanged: (value) {
        setState(() {
          _selectedTab = value;
        });
      },
    );
  }
}
