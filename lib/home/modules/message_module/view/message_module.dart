import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/home/modules/message_module/bloc/message_module_bloc.dart';
import 'package:studipadawan/home/modules/message_module/bloc/message_module_state.dart';
import 'package:studipadawan/home/modules/module_card.dart';

class MessageModule extends StatelessWidget {
  const MessageModule({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MoudleCard(
      headline: 'Nachrichten',
      module: BlocProvider(
        create: (context) => MessageModuleBloc(
          messageRepository: context.read<MessageRepository>(),
          authenticationRepository: context.read<AuthenticationRepository>(),
        ),
        child: BlocBuilder<MessageModuleBloc, MessageModuleState>(
          builder: (context, state) {
            return const Text('Moin');
          },
        ),
      ),
    );
  }
}
