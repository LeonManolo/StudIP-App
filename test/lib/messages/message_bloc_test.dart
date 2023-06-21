import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc%20/message_inbox_bloc.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc%20/message_inbox_event.dart';
import 'package:studipadawan/messages/message_overview/message_inbox_bloc%20/message_inbox_state.dart';
import 'package:studipadawan/messages/message_overview/message_outbox_bloc/message_outbox_bloc.dart';
import 'package:studipadawan/messages/message_overview/message_outbox_bloc/message_outbox_event.dart';
import 'package:studipadawan/messages/message_overview/message_outbox_bloc/message_outbox_state.dart';

import '../../helpers/hydrated_bloc.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockMessageRepository extends Mock implements MessageRepository {}

void main() {
  initHydratedBloc();
  late MockMessageRepository mockedMessageRepository;
  late MockAuthenticationRepository mockedAuthenticationRepository;

  setUp(() {
    mockedMessageRepository = MockMessageRepository();
    mockedAuthenticationRepository = MockAuthenticationRepository();
  });

  group('OutboxMessageBloc', () {
    final message1 = Message(
      id: '1',
      subject: '',
      message: 'Message 1',
      sender: MessageUser.empty(),
      recipients: [],
      mkdate: DateTime.now(),
      isRead: true,
    );

    final message2 = Message(
      id: '2',
      subject: '',
      message: 'Message 2',
      sender: MessageUser.empty(),
      recipients: [],
      mkdate: DateTime.now(),
      isRead: true,
    );

    test('initial state is correct', () {
      final bloc = OutboxMessageBloc(
        messageRepository: mockedMessageRepository,
        authenticationRepository: mockedAuthenticationRepository,
      );
      expect(bloc.state, const OutboxMessageState.initial());
      bloc.close();
    });

    blocTest<OutboxMessageBloc, OutboxMessageState>(
      'emits correct states when OutboxMessagesRequested event is added',
      setUp: () {
        when(
          () => mockedAuthenticationRepository.currentUser,
        ).thenAnswer((_) => const User('1'));
        when(
          () => mockedMessageRepository.getOutboxMessages(
            userId: any(named: 'userId'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) => Future.value([message1, message2]));
      },
      build: () => OutboxMessageBloc(
        messageRepository: mockedMessageRepository,
        authenticationRepository: mockedAuthenticationRepository,
      ),
      act: (bloc) => bloc.add(const OutboxMessagesRequested(offset: 0)),
      expect: () => [
        const OutboxMessageState(
          status: OutboxMessageStatus.loading,
        ),
        OutboxMessageState(
          status: OutboxMessageStatus.populated,
          maxReached: true,
          outboxMessages: [message1, message2],
        ),
      ],
    );

    blocTest<OutboxMessageBloc, OutboxMessageState>(
      'emits correct states when RefreshOutboxRequested event is added',
      setUp: () {
        when(
          () => mockedAuthenticationRepository.currentUser,
        ).thenAnswer((_) => const User('1'));
        when(
          () => mockedMessageRepository.getOutboxMessages(
            userId: any(named: 'userId'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) => Future.value([message1, message2]));
      },
      build: () => OutboxMessageBloc(
        messageRepository: mockedMessageRepository,
        authenticationRepository: mockedAuthenticationRepository,
      ),
      act: (bloc) => bloc.add(const RefreshOutboxRequested()),
      expect: () => [
        const OutboxMessageState(
          status: OutboxMessageStatus.loading,
        ),
        OutboxMessageState(
          status: OutboxMessageStatus.populated,
          outboxMessages: [message1, message2],
        ),
      ],
    );

    blocTest<OutboxMessageBloc, OutboxMessageState>(
      'emits correct states when DeleteOutboxMessagesRequested event is added',
      setUp: () {
        when(
          () => mockedAuthenticationRepository.currentUser,
        ).thenAnswer((_) => const User('1'));
        when(
          () => mockedMessageRepository.deleteMessages(
              messageIds: any(named: 'messageIds'),),
        ).thenAnswer((_) => Future.value());
        when(
          () => mockedMessageRepository.getOutboxMessages(
            userId: any(named: 'userId'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) => Future.value([message2]));
      },
      build: () => OutboxMessageBloc(
        messageRepository: mockedMessageRepository,
        authenticationRepository: mockedAuthenticationRepository,
      ),
      act: (bloc) =>
          bloc.add(const DeleteOutboxMessagesRequested(messageIds: ['1'])),
      expect: () => [
        const OutboxMessageState(
          status: OutboxMessageStatus.loading,
        ),
        OutboxMessageState(
          status: OutboxMessageStatus.deleteOutboxMessagesSucceed,
          blocResponse: messageDeleteSucceed,
          maxReached: true,
          outboxMessages: [message2],
        ),
      ],
    );
  });

  group('InboxMessageBloc', () {
    final message1 = Message(
      id: '1',
      subject: '',
      message: 'Message 1',
      sender: MessageUser.empty(),
      recipients: [],
      mkdate: DateTime.now(),
      isRead: true,
    );

    final message2 = Message(
      id: '2',
      subject: '',
      message: 'Message 2',
      sender: MessageUser.empty(),
      recipients: [],
      mkdate: DateTime.now(),
      isRead: true,
    );

    test('initial state is correct', () {
      final bloc = InboxMessageBloc(
        messageRepository: mockedMessageRepository,
        authenticationRepository: mockedAuthenticationRepository,
      );
      expect(bloc.state, const InboxMessageState.initial());
      bloc.close();
    });

    blocTest<InboxMessageBloc, InboxMessageState>(
      'emits correct states when InboxMessagesRequested event is added',
      setUp: () {
        when(
          () => mockedAuthenticationRepository.currentUser,
        ).thenReturn(const User('1'));
        when(
          () => mockedMessageRepository.getInboxMessages(
            userId: any(named: 'userId'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            filterUnread: any(named: 'filterUnread'),
          ),
        ).thenAnswer((_) => Future.value([message1, message2]));
      },
      build: () => InboxMessageBloc(
        messageRepository: mockedMessageRepository,
        authenticationRepository: mockedAuthenticationRepository,
      ),
      act: (bloc) => bloc.add(
        const InboxMessagesRequested(offset: 0, filter: MessageFilter.none),
      ),
      expect: () => [
        const InboxMessageState(status: InboxMessageStatus.loading),
        InboxMessageState(
          status: InboxMessageStatus.populated,
          maxReached: true,
          inboxMessages: [message1, message2],
        ),
      ],
    );

    blocTest<InboxMessageBloc, InboxMessageState>(
      'emits correct states when RefreshInboxRequested event is added',
      setUp: () {
        when(
          () => mockedAuthenticationRepository.currentUser,
        ).thenReturn(const User('1'));
        when(
          () => mockedMessageRepository.getInboxMessages(
            userId: any(named: 'userId'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            filterUnread: any(named: 'filterUnread'),
          ),
        ).thenAnswer((_) => Future.value([message1, message2]));
      },
      build: () => InboxMessageBloc(
        messageRepository: mockedMessageRepository,
        authenticationRepository: mockedAuthenticationRepository,
      ),
      act: (bloc) => bloc.add(const RefreshInboxRequested()),
      expect: () => [
        const InboxMessageState(status: InboxMessageStatus.loading),
        InboxMessageState(
          status: InboxMessageStatus.populated,
          maxReached: true,
          inboxMessages: [message1, message2],
        ),
      ],
    );

    blocTest<InboxMessageBloc, InboxMessageState>(
      'emits correct states when DeleteInboxMessagesRequested event is added',
      setUp: () {
        when(
          () => mockedAuthenticationRepository.currentUser,
        ).thenReturn(const User('1'));
        when(
          () => mockedMessageRepository.deleteMessages(
            messageIds: any(named: 'messageIds'),
          ),
        ).thenAnswer((_) => Future.value());
        when(
          () => mockedMessageRepository.getInboxMessages(
            userId: any(named: 'userId'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            filterUnread: any(named: 'filterUnread'),
          ),
        ).thenAnswer((_) => Future.value([message2]));
      },
      build: () => InboxMessageBloc(
        messageRepository: mockedMessageRepository,
        authenticationRepository: mockedAuthenticationRepository,
      ),
      act: (bloc) =>
          bloc.add(const DeleteInboxMessagesRequested(messageIds: ['1'])),
      expect: () => [
        const InboxMessageState(status: InboxMessageStatus.loading),
        InboxMessageState(
          status: InboxMessageStatus.deleteInboxMessagesSucceed,
          blocResponse: messageDeleteSucceed,
          maxReached: true,
          inboxMessages: [message2],
        ),
      ],
    );
  });
}
