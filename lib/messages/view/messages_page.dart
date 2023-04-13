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
    MessageFilter currentFilter = MessageFilter.none;

    final messageBloc = MessageBloc(
        messageRepository: context.read<MessageRepository>(),
        authenticationRepository: context.read<AuthenticationRepository>())
      ..add(RefreshRequested(filter: currentFilter));

    handleFilterSelection(MessageFilter filter) {
      currentFilter = filter;
      messageBloc.add(RefreshRequested(filter: filter));
    }

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
          )
        ],
      ),
      body: BlocBuilder<MessageBloc, MessageState>(
          bloc: messageBloc,
          builder: (context, state) {
            return Column(children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 5),
                    child: ToggleButtons(
                        direction: Axis.horizontal,
                        onPressed: (int index) {
                          if (state.isInbox && index == 1 ||
                              !state.isInbox && index == 0) {
                            messageBloc.add(InboxOutboxToggleBoxDidChange(
                                index: index, filter: currentFilter));
                          }
                        },
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
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
                  ),
                  const Spacer(),
                  PopupMenuButton<MessageFilter>(
                      onSelected: (newFilter) =>
                          handleFilterSelection(newFilter),
                      itemBuilder: (context) => [
                            const PopupMenuItem<MessageFilter>(
                                value: MessageFilter.none,
                                child: Text('Kein Filter')),
                            const PopupMenuItem<MessageFilter>(
                                value: MessageFilter.unread,
                                child: Text('Ungelesene Nachrichten')),
                            const PopupMenuItem<MessageFilter>(
                                value: MessageFilter.read,
                                child: Text('Gelesene Nachrichten'))
                          ])
                ],
              ),
              Expanded(
                child: state.status != MessageStatus.populated
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: () async => {
                          messageBloc
                              .add(RefreshRequested(filter: currentFilter))
                        },
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
