import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/home/modules/message_module/bloc/message_module_event.dart';
import 'package:studipadawan/home/modules/message_module/bloc/message_module_state.dart';

const int previewLimit = 4;

class MessageModuleBloc extends Bloc<MessageModuleEvent, MessageModuleState> {
  MessageModuleBloc({
    required MessageRepository messageRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _messageRepository = messageRepository,
        _authenticationRepository = authenticationRepository,
        super(const MessageModuleStateInitial()) {
    on<MessagePreviewRequested>(_onMessagePreviesRequested);
  }
  final MessageRepository _messageRepository;
  final AuthenticationRepository _authenticationRepository;

  Future<void> _onMessagePreviesRequested(
    MessagePreviewRequested event,
    Emitter<MessageModuleState> emit,
  ) async {
    emit(const MessageModuleStateLoading());

    try {
      final previewMessages = await _messageRepository.getInboxMessages(
        userId: _authenticationRepository.currentUser.id,
        offset: 0,
        limit: previewLimit,
        filterUnread: false,
      );
      emit(MessageModuleStateDidLoad(previewMessages: previewMessages));
    } catch (_) {
      emit(const MessageModuleStateError());
    }
  }
}
