import 'package:app_ui/app_ui.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class CalendarDetailPage extends StatelessWidget {
  const CalendarDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Benachrichtigungen (Softwarearchitektur)'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Erinnerung",
                  style: Theme.of(context).textTheme.titleLarge,),
                RadioListTile(
                  title: Text("5 Minuten vorher"),
                  value: "Apple",
                  groupValue: "",
                  onChanged: (_) => {},
                ),
                RadioListTile(
                  title: Text("15 Minuten vorher"),
                  value: "Apple",
                  groupValue: "",
                  onChanged: (_) => {},
                ),
                RadioListTile(
                  title: Text("1 Stunde vorher"),
                    selected: true,
                    value: "Apple",
                    groupValue: "Apple",
                    onChanged: (_) => {},
                ),
                Divider(
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Termine",
                      style: Theme.of(context).textTheme.titleLarge,),
                    TextButton(onPressed: () {}, child: Text("ALLE AUSWÄHLEN")),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            enabled: false,
            title: const Text('13.04.2023, 10:00 - 11:30 (A212)'),
            subtitle: const Text('Softwarearchitektur - Vorlesung'),
          ),
          ListTile(
            //enabled: false,
            title: const Text('18.04.2023, 10:00 - 11:30 (A212)'),
            subtitle: const Text('Softwarearchitektur - Vorlesung'),
            trailing: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.15),
              child: Icon(EvaIcons.checkmark, color: Theme.of(context).primaryColor,),
            ),
          ),
          ListTile(
            //enabled: false,
            title: const Text('13.04.2023, 10:00 - 11:30 (A212)'),
            subtitle: const Text('Softwarearchitektur - Vorlesung'),
            trailing: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.15),
              child: Icon(EvaIcons.checkmark, color: Theme.of(context).primaryColor,),
            ),
          ),
          ListTile(
            //enabled: false,
            title: const Text('13.04.2023, 10:00 - 11:30 (A212)'),
            subtitle: const Text('Softwarearchitektur - Vorlesung'),
          ),
        ],
      ),
    );
  }
}
