import 'package:app_ui/app_ui.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class CalendarDetailPage extends StatelessWidget {
  const CalendarDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () async {
            //await LocalNotifications.scheduleNotification();
            }, icon: const Icon(EvaIcons.alertCircle),),
        ],
        title: SizedBox(
          height: 80,
          child: Marquee(
            pauseAfterRound: const Duration(seconds: 5),
            text: 'Benachrichtigungen (Softwarearchitektur)',
            //style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Text(
                    'Erinnerung',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                DropdownButtonHideUnderline(child: DropdownButton2(
                    items: const [
                  DropdownMenuItem<int>(
                      value: 1,
                      child: Text('15 min'),),
                  DropdownMenuItem<int>(
                    value: 2,
                      child: Text('16 min'),
                  ),
                ],),),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Termine',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(
                        onPressed: () {}, child: const Text('ALLE AUSWÄHLEN'),),
                  ],
                ),
              ],
            ),
          ),
          const ListTile(
            enabled: false,
            title: Text('13.04.2023, 10:00 - 11:30 (A212)'),
            subtitle: Text('Softwarearchitektur - Vorlesung'),
          ),
          ListTile(
            //enabled: false,
            title: const Text('18.04.2023, 10:00 - 11:30 (A212)'),
            subtitle: const Text('Softwarearchitektur - Vorlesung'),
            trailing: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.15),
              child: Icon(
                EvaIcons.checkmark,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          ListTile(
            //enabled: false,
            title: const Text('13.04.2023, 10:00 - 11:30 (A212)'),
            subtitle: const Text('Softwarearchitektur - Vorlesung'),
            trailing: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.15),
              child: Icon(
                EvaIcons.checkmark,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          const ListTile(
            //enabled: false,
            title: Text('13.04.2023, 10:00 - 11:30 (A212)'),
            subtitle: Text('Softwarearchitektur - Vorlesung'),
          ),
        ],
      ),
    );
  }
}
