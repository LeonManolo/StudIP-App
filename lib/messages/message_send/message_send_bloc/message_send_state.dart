import 'package:equatable/equatable.dart';
import 'package:messages_repository/messages_repository.dart';

sealed class MessageSendState extends Equatable {
  const MessageSendState({
    this.recipients = const [],
    this.suggestions = const [],
    this.blocResponse = '',
  });
  final List<MessageUser> recipients;
  final List<MessageUser> suggestions;
  final String blocResponse;

  MessageSendState copyWith({
    List<MessageUser>? recipients,
    List<MessageUser>? suggestions,
    String? blocResponse,
  });

  @override
  List<Object?> get props => [recipients, suggestions, blocResponse];
}

class MessageSendStateInitial extends MessageSendState {
  const MessageSendStateInitial({
    super.recipients,
    super.suggestions,
    super.blocResponse,
  });

  @override
  MessageSendStateInitial copyWith({
    List<MessageUser>? recipients,
    List<MessageUser>? suggestions,
    String? blocResponse,
  }) {
    return MessageSendStateInitial(
      recipients: recipients ?? this.recipients,
      suggestions: suggestions ?? this.suggestions,
      blocResponse: blocResponse ?? this.blocResponse,
    );
  }

  @override
  List<Object?> get props => [recipients, suggestions, blocResponse];
}

class MessageSendStateRecipientsChanged extends MessageSendState {
  const MessageSendStateRecipientsChanged({
    super.recipients,
    super.suggestions,
    super.blocResponse,
  });

  factory MessageSendStateRecipientsChanged.fromState(MessageSendState state) =>
      MessageSendStateRecipientsChanged(
        recipients: state.recipients,
        suggestions: state.suggestions,
        blocResponse: state.blocResponse,
      );

  @override
  MessageSendStateRecipientsChanged copyWith({
    List<MessageUser>? recipients,
    List<MessageUser>? suggestions,
    String? blocResponse,
  }) {
    return MessageSendStateRecipientsChanged(
      recipients: recipients ?? this.recipients,
      suggestions: suggestions ?? this.suggestions,
      blocResponse: blocResponse ?? this.blocResponse,
    );
  }

  @override
  List<Object?> get props => [recipients, suggestions, blocResponse];
}

class MessageSendStateUserSuggestionsFetched extends MessageSendState {
  const MessageSendStateUserSuggestionsFetched({
    super.recipients,
    super.suggestions,
    super.blocResponse,
  });

  factory MessageSendStateUserSuggestionsFetched.fromState(
          MessageSendState state) =>
      MessageSendStateUserSuggestionsFetched(
        recipients: state.recipients,
        suggestions: state.suggestions,
        blocResponse: state.blocResponse,
      );

  @override
  MessageSendStateUserSuggestionsFetched copyWith({
    List<MessageUser>? recipients,
    List<MessageUser>? suggestions,
    String? blocResponse,
  }) {
    return MessageSendStateUserSuggestionsFetched(
      recipients: recipients ?? this.recipients,
      suggestions: suggestions ?? this.suggestions,
      blocResponse: blocResponse ?? this.blocResponse,
    );
  }

  @override
  List<Object?> get props => [recipients, suggestions, blocResponse];
}

class MessageSendStateUserSuggestionsError extends MessageSendState {
  const MessageSendStateUserSuggestionsError({
    super.recipients,
    super.suggestions,
    super.blocResponse,
  });

  factory MessageSendStateUserSuggestionsError.fromState(
          MessageSendState state) =>
      MessageSendStateUserSuggestionsError(
        recipients: state.recipients,
        suggestions: state.suggestions,
        blocResponse: state.blocResponse,
      );

  @override
  MessageSendStateUserSuggestionsError copyWith({
    List<MessageUser>? recipients,
    List<MessageUser>? suggestions,
    String? blocResponse,
  }) {
    return MessageSendStateUserSuggestionsError(
      recipients: recipients ?? this.recipients,
      suggestions: suggestions ?? this.suggestions,
      blocResponse: blocResponse ?? this.blocResponse,
    );
  }

  @override
  List<Object?> get props => [recipients, suggestions, blocResponse];
}

class MessageSendStateLoading extends MessageSendState {
  const MessageSendStateLoading({
    super.recipients,
    super.suggestions,
    super.blocResponse,
  });

  factory MessageSendStateLoading.fromState(MessageSendState state) =>
      MessageSendStateLoading(
        recipients: state.recipients,
        suggestions: state.suggestions,
        blocResponse: state.blocResponse,
      );

  @override
  MessageSendStateLoading copyWith({
    List<MessageUser>? recipients,
    List<MessageUser>? suggestions,
    String? blocResponse,
  }) {
    return MessageSendStateLoading(
      recipients: recipients ?? this.recipients,
      suggestions: suggestions ?? this.suggestions,
      blocResponse: blocResponse ?? '',
    );
  }

  @override
  List<Object?> get props => [recipients, suggestions, blocResponse];
}

class MessageSendStateDidLoad extends MessageSendState {
  const MessageSendStateDidLoad({
    super.recipients,
    super.suggestions,
    super.blocResponse,
  });

  factory MessageSendStateDidLoad.fromState(MessageSendState state) =>
      MessageSendStateDidLoad(
        recipients: state.recipients,
        suggestions: state.suggestions,
        blocResponse: state.blocResponse,
      );

  @override
  MessageSendStateDidLoad copyWith({
    List<MessageUser>? recipients,
    List<MessageUser>? suggestions,
    String? blocResponse,
  }) {
    return MessageSendStateDidLoad(
      recipients: recipients ?? this.recipients,
      suggestions: suggestions ?? this.suggestions,
      blocResponse: blocResponse ?? blocResponse ?? '',
    );
  }

  @override
  List<Object?> get props => [recipients, suggestions, blocResponse];
}

class MessageSendStateError extends MessageSendState {
  const MessageSendStateError({
    super.recipients,
    super.suggestions,
    super.blocResponse,
  });

  factory MessageSendStateError.fromState(MessageSendState state) =>
      MessageSendStateError(
        recipients: state.recipients,
        suggestions: state.suggestions,
        blocResponse: state.blocResponse,
      );

  @override
  MessageSendStateError copyWith({
    List<MessageUser>? recipients,
    List<MessageUser>? suggestions,
    String? blocResponse,
  }) {
    return MessageSendStateError(
      recipients: recipients ?? this.recipients,
      suggestions: suggestions ?? this.suggestions,
      blocResponse: blocResponse ?? '',
    );
  }

  @override
  List<Object?> get props => [recipients, suggestions, blocResponse];
}
