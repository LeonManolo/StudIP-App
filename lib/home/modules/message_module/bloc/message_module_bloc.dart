import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/home/modules/bloc/module_bloc.dart';
import 'package:studipadawan/home/modules/message_module/model/message_preview_model.dart';

class MessageModuleBloc extends ModuleBloc {
  MessageModuleBloc({
    required MessageRepository messageRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _messageRepository = messageRepository,
        _authenticationRepository = authenticationRepository,
        super();

  @override
  String get emptyViewMessage => 'Keine aktuellen Nachrichten vorhanden.';

  final MessageRepository _messageRepository;
  final AuthenticationRepository _authenticationRepository;

  @override
  Future<void> onModuleItemsRequested(
    ModuleItemsRequested event,
    Emitter<ModuleState> emit,
  ) async {
    try {
      final messages = await _messageRepository.getInboxMessages(
        userId: _authenticationRepository.currentUser.id,
        offset: 0,
        limit: previewLimit,
        filterUnread: false,
      );
      emit(
        ModuleLoaded(
          previewModels: messages
              .map(
                (message) => MessagePreviewModel(message: message),
              )
              .toList(),
        ),
      );
    } catch (e) {
      Logger().e(e);
      emit(
        const ModuleError(
          errorMessage:
              'Beim Laden der Nachrichten ist ein Fehler aufgetreten.',
        ),
      );
    }
  }
}
