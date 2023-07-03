import 'package:activity_repository/activity_repository.dart';
import 'package:app_ui/app_ui.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:calender_repository/calender_repository.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/home/cubit/home_cubit.dart';
import 'package:studipadawan/home/models/preview_model.dart';
import 'package:studipadawan/home/modules/calendar_module/bloc/calendar_module_bloc.dart';
import 'package:studipadawan/home/modules/files_module/bloc/files_module_bloc.dart';
import 'package:studipadawan/home/modules/message_module/bloc/message_module_bloc.dart';
import 'package:studipadawan/home/modules/news_module/bloc/news_module_bloc.dart';
import 'package:studipadawan/home/profile/view/profile_page.dart';
import 'package:studipadawan/home/utils/module_factory.dart';
import 'package:studipadawan/home/view/widgets/module_card.dart';
import 'package:studipadawan/home/view/widgets/module_card_view.dart';
import 'package:studipadawan/home/view/widgets/module_reorderable_list.dart';
import 'package:studipadawan/home/view/widgets/module_selection_modal.dart';
import 'package:studipadawan/utils/empty_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final authenticationRepository =
            context.read<AuthenticationRepository>();
        final activityRepository = context.read<ActivityRepository>();

        return HomeCubit(
          moduleBlocs: {
            ModuleType.calendar: CalendarModuleBloc(
              calendarRepository: context.read<CalenderRepository>(),
              authenticationRepository: authenticationRepository,
            ),
            ModuleType.files: FilesModuleBloc(
              activityRepository: activityRepository,
              authenticationRepository: authenticationRepository,
            ),
            ModuleType.messages: MessageModuleBloc(
              messageRepository: context.read<MessageRepository>(),
              authenticationRepository: authenticationRepository,
            ),
            ModuleType.news: NewsModuleBloc(
              activityRepository: activityRepository,
              authenticationRepository: authenticationRepository,
            ),
          },
        );
      },
      child: const HomePageView(),
    );
  }
}

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(EvaIcons.personOutline),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<ProfilePage>(
                  fullscreenDialog: true,
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
          )
        ],
      ),
      floatingActionButton: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return FloatingActionButton(
            child: const Icon(EvaIcons.editOutline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<ModuleSelectionModal>(
                  builder: (_) => ModuleSelectionModal(
                    selectedModules: List.of(
                      context.read<HomeCubit>().state.selectedModules,
                    ),
                    onSavePressed: (newSelectedModules) {
                      context.read<HomeCubit>().overrideSelectedModules(
                            modules: newSelectedModules,
                          );
                    },
                  ),
                  fullscreenDialog: true,
                ),
              );
            },
          );
        },
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Expanded(
                child: state.selectedModules.isEmpty
                    ? const Center(
                        child: EmptyView(
                          title: 'Keine Module vorhanden',
                          message:
                              'Füge jetzt über den Edit-Button neue Module hinzu.',
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        child: ReorderableModuleListView(
                          modules: state.selectedModules.map((moduleType) {
                            return BlocProvider.value(
                              value: context
                                  .read<HomeCubit>()
                                  .moduleBlocs[moduleType]!,
                              child: ModuleCard(
                                title: moduleType.title,
                                child: ModuleCardView<PreviewModel>(
                                  listTile: (previewModel) {
                                    return moduleListTileFactory(
                                      type: moduleType,
                                      previewModel: previewModel,
                                      onRefresh: () => context
                                          .read<HomeCubit>()
                                          .refreshModule(
                                            moduleType: moduleType,
                                          ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
              )
            ],
          );
        },
      ),
    );
  }
}
