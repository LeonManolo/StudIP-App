import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:studipadawan/home/modules/message_module/bloc/message_module_event.dart';
import 'package:studipadawan/home/modules/message_module/bloc/message_module_state.dart';

class MessageModuleBloc extends Bloc<MessageModuleEvent, MessageModuleState> {
  MessageModuleBloc({
    required MessageRepository messageRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _messageRepository = messageRepository,
        _authenticationRepository = authenticationRepository,
        super(const MessageModuleState.initial()) {}
  final MessageRepository _messageRepository;
  final AuthenticationRepository _authenticationRepository;
}
