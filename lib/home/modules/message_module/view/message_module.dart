import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/home/cubit/home_cubit.dart';
import 'package:studipadawan/home/modules/message_module/bloc/message_module_bloc.dart';
import 'package:studipadawan/home/modules/message_module/bloc/message_module_event.dart';
import 'package:studipadawan/home/modules/message_module/bloc/message_module_state.dart';
import 'package:studipadawan/home/modules/message_module/view/widgets/message_preview_list.dart';
import 'package:studipadawan/home/modules/module.dart';
import 'package:studipadawan/home/modules/module_card.dart';
import 'package:studipadawan/utils/empty_view.dart';

class MessageModule extends StatefulWidget implements Module {
  const MessageModule({
    super.key,
  });

  static const type = ModuleType.messages;

  @override
  ModuleType getType() {
    return MessageModule.type;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': MessageModule.type.name,
    };
  }

  @override
  State<MessageModule> createState() => _MessageModuleState();
}

class _MessageModuleState extends State<MessageModule> {
  late Timer _refreshTimer;
  late MessageModuleBloc _messageModuleBloc;
  @override
  void initState() {
    super.initState();
    _messageModuleBloc = MessageModuleBloc(
      messageRepository: context.read<MessageRepository>(),
      authenticationRepository: context.read<AuthenticationRepository>(),
    )..add(const MessagePreviewRequested());
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _messageModuleBloc.add(const MessagePreviewRequested());
    });
  }

  @override
  void dispose() {
    super.dispose();
    _messageModuleBloc.close();
    _refreshTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ModuleCard(
      type: MessageModule.type,
      child: BlocProvider.value(
        value: _messageModuleBloc,
        child: BlocBuilder<MessageModuleBloc, MessageModuleState>(
          builder: (context, state) {
            switch (state) {
              case MessageModuleStateInitial _:
                return Container();
              case MessageModuleStateLoading _:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case MessageModuleStateDidLoad _:
                return MessagePreviewList(
                  messageModuleBloc: _messageModuleBloc,
                  messages: state.previewMessages,
                );
              case MessageModuleStateError _:
                return const EmptyView(
                  title: 'Es ist ein Fehler aufgetreten',
                  message: 'Es konnten keine Nachrichten gefetcht werden',
                );
            }
          },
        ),
      ),
    );
  }
}
