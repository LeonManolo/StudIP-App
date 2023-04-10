import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/messages/bloc/message_bloc.dart';
import 'package:studipadawan/messages/bloc/message_event.dart';
import 'package:studipadawan/messages/bloc/message_state.dart';
import 'package:studipadawan/messages/view/widgets/InboxMessageWidget.dart';
import 'package:studipadawan/messages/view/widgets/OutboxMessageWidget.dart';
import 'package:user_repository/user_repository.dart';

import '../../app/bloc/app_bloc.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({Key? key}) : super(key: key);

  static Page<void> page() => const MaterialPage<void>(child: MessagesPage());

  @override
  Widget build(BuildContext context) {
    final messageBloc = MessageBloc(
        messageRepository: context.read<MessageRepository>(),
        authenticationRepository: context.read<AuthenticationRepository>())
      ..add(const RefreshRequested());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nachrichten"),
        actions: <Widget>[
          IconButton(
            key: const Key('homePage_logout_iconButton'),
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              context.read<AppBloc>().add(const AppLogoutRequested());
            },
          ),
          IconButton(
              onPressed: () {
                context
                    .read<UserRepository>()
                    .getCurrentUser()
                    .then((value) => print("${value.email} ${value.username}"));
              },
              icon: const Icon(Icons.download))
        ],
      ),
      body: BlocBuilder<MessageBloc, MessageState>(
          bloc: messageBloc,
          builder: (context, state) {
            return Column(children: [
              ToggleButtons(
                  direction: Axis.horizontal,
                  onPressed: (int index) {
                    if (state.isInbox && index == 1 ||
                        !state.isInbox && index == 0) {
                      messageBloc
                          .add(InboxOutboxToggleBoxDidChange(index: index));
                    }
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: Colors.white,
                  selectedColor: Colors.white,
                  fillColor: Colors.blue,
                  color: Colors.black,
                  constraints: const BoxConstraints(
                    minHeight: 30.0,
                    minWidth: 80.0,
                  ),
                  isSelected: state.toggleBoxStates,
                  children: state.toggleBoxLabels
                      .map((labelString) => Text(labelString))
                      .toList()),
              Expanded(
                child: state.status != MessageStatus.populated
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: () async =>
                            {messageBloc.add(const RefreshRequested())},
                        child: ListView.separated(
                          itemCount: state.messages.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return state.isInbox
                                ? InboxMessageWidget(
                                    message: state.messages[index])
                                : OutboxMessageWidget(
                                    message: state.messages[index]);
                          },
                          separatorBuilder: (context, index) {
                            return const Divider();
                          },
                        ),
                      ),
              )
            ]);
          }),
    );
  }
}
