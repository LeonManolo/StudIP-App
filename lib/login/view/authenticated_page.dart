import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:studipadawan/calendar/view/calendar_page.dart';
import 'package:studipadawan/courses/view/courses_page.dart';
import 'package:studipadawan/home/view/home_page.dart';

import '../../messages/messages/view/messages_page.dart';


class AuthenticatedPage extends StatefulWidget {
  const AuthenticatedPage({Key? key}) : super(key: key);

  static Page<void> page() =>
      const MaterialPage<void>(child: AuthenticatedPage());

  @override
  State<AuthenticatedPage> createState() => _AuthenticatedPageState();
}

class _AuthenticatedPageState extends State<AuthenticatedPage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedTab,
        children: const [
          HomePage(),
          CoursesPage(),
          MessagesPage(),
          CalendarPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              label: "Home",
              icon: Icon(EvaIcons.homeOutline),
              activeIcon: Icon(EvaIcons.home)),
          BottomNavigationBarItem(
              label: "Kurse",
              icon: Icon(EvaIcons.bookOpenOutline),
              activeIcon: Icon(EvaIcons.bookOpen)),
          BottomNavigationBarItem(
              label: "Nachrichten",
              icon: Icon(EvaIcons.messageSquareOutline),
              activeIcon: Icon(EvaIcons.messageSquare)),
          BottomNavigationBarItem(
              label: "Kalender",
              icon: Icon(EvaIcons.calendarOutline),
              activeIcon: Icon(EvaIcons.calendar)),
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
