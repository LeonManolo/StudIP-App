import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/app/bloc/app_bloc.dart';
import 'package:studipadawan/home/modules/files_module/view/files_module.dart';
import 'package:studipadawan/home/modules/message_module/view/message_module.dart';
import 'package:studipadawan/home/modules/news_module/view/news_module.dart';
import 'package:studipadawan/home/modules/schedule_module/view/schedule_module.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    const double largeSpacing = AppSpacing.lg;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
            key: const Key('homePage_logout_iconButton'),
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              context.read<AppBloc>().add(const AppLogoutRequested());
            },
          )
        ],
      ),
      body: ListView(
        children: const <Widget>[
          FilesModule(),
          SizedBox(height: largeSpacing),
          MessageModule(),
          SizedBox(height: largeSpacing),
          ScheduleModule(),
          SizedBox(height: largeSpacing),
          NewsModule(),
          SizedBox(height: largeSpacing),
        ],
      ),
    );
  }
}

/***
 *  ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {

        }
      ),
 */
