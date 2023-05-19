import 'package:flutter/material.dart';

class CalendarScheduleNotificationsPage extends StatelessWidget {
  const CalendarScheduleNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Benachrichtigungen"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ExpansionTile(title: Text("Software")),
            ExpansionTile(title: Text("Software")),
          ],
        ),
      ),
    );
  }
}
