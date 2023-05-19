import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/home/cubit/home_cubit.dart';
import 'package:studipadawan/home/modules/message_module/bloc/message_module_bloc.dart';
import 'package:studipadawan/home/modules/message_module/bloc/message_module_state.dart';
import 'package:studipadawan/home/modules/module.dart';
import 'package:studipadawan/home/modules/module_card.dart';

class MessageModule extends StatelessWidget implements Module {
  const MessageModule({
    super.key,
  });

  static const type = ModuleType.messages;

  @override
  Widget build(BuildContext context) {
    return MoudleCard(
      type: type,
      child: BlocProvider(
        create: (context) => MessageModuleBloc(
          messageRepository: context.read<MessageRepository>(),
          authenticationRepository: context.read<AuthenticationRepository>(),
        ),
        child: BlocBuilder<MessageModuleBloc, MessageModuleState>(
          builder: (context, state) {
            return const Text('Content');
          },
        ),
      ),
    );
  }

  @override
  ModuleType getType() {
    return type;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
    };
  }
}
