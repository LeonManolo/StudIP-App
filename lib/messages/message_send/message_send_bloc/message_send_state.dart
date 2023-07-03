import 'package:equatable/equatable.dart';
import 'package:messages_repository/messages_repository.dart';

sealed class MessageSendState extends Equatable {
  const MessageSendState({
    this.recipients = const [],
    this.suggestions = const [],
    this.failureInfo = '',
    this.successInfo = '',
  });
  final List<MessageUser> recipients;
  final List<MessageUser> suggestions;
  final String failureInfo;
  final String successInfo;

  MessageSendState copyWith({
    List<MessageUser>? recipients,
    List<MessageUser>? suggestions,
    String? failureInfo,
    String? successInfo,
  });

  @override
  List<Object?> get props =>
      [recipients, suggestions, failureInfo, successInfo];
}

class MessageSendStateInitial extends MessageSendState {
  const MessageSendStateInitial({
    super.recipients,
    super.suggestions,
    super.failureInfo,
    super.successInfo,
  });

  @override
  MessageSendStateInitial copyWith({
    List<MessageUser>? recipients,
    List<MessageUser>? suggestions,
    String? failureInfo,
    String? successInfo,
  }) {
    return MessageSendStateInitial(
      recipients: recipients ?? this.recipients,
      suggestions: suggestions ?? this.suggestions,
      failureInfo: failureInfo ?? this.failureInfo,
      successInfo: successInfo ?? this.successInfo,
    );
  }
}

class MessageSendStateRecipientsChanged extends MessageSendState {
  const MessageSendStateRecipientsChanged({
    super.recipients,
    super.suggestions,
    super.failureInfo,
    super.successInfo,
  });

  factory MessageSendStateRecipientsChanged.fromState(MessageSendState state) =>
      MessageSendStateRecipientsChanged(
        recipients: state.recipients,
        suggestions: state.suggestions,
      );

  @override
  MessageSendStateRecipientsChanged copyWith({
    List<MessageUser>? recipients,
    List<MessageUser>? suggestions,
    String? failureInfo,
    String? successInfo,
  }) {
    return MessageSendStateRecipientsChanged(
      recipients: recipients ?? this.recipients,
      suggestions: suggestions ?? this.suggestions,
    );
  }
}

class MessageSendStateUserSuggestionsFetched extends MessageSendState {
  const MessageSendStateUserSuggestionsFetched({
    super.recipients,
    super.suggestions,
    super.failureInfo,
    super.successInfo,
  });

  factory MessageSendStateUserSuggestionsFetched.fromState(
    MessageSendState state,
  ) =>
      MessageSendStateUserSuggestionsFetched(
        recipients: state.recipients,
        suggestions: state.suggestions,
      );

  @override
  MessageSendStateUserSuggestionsFetched copyWith({
    List<MessageUser>? recipients,
    List<MessageUser>? suggestions,
    String? blocResponse,
    String? failureInfo,
    String? successInfo,
  }) {
    return MessageSendStateUserSuggestionsFetched(
      recipients: recipients ?? this.recipients,
      suggestions: suggestions ?? this.suggestions,
      failureInfo: failureInfo ?? this.failureInfo,
      successInfo: successInfo ?? this.successInfo,
    );
  }
}

class MessageSendStateUserSuggestionsError extends MessageSendState {
  const MessageSendStateUserSuggestionsError({
    super.recipients,
    super.suggestions,
    super.failureInfo,
    super.successInfo,
  });

  factory MessageSendStateUserSuggestionsError.fromState(
    MessageSendState state,
  ) =>
      MessageSendStateUserSuggestionsError(
        recipients: state.recipients,
        suggestions: state.suggestions,
        failureInfo: state.failureInfo,
      );

  @override
  MessageSendStateUserSuggestionsError copyWith({
    List<MessageUser>? recipients,
    List<MessageUser>? suggestions,
    String? failureInfo,
    String? successInfo,
  }) {
    return MessageSendStateUserSuggestionsError(
      recipients: recipients ?? this.recipients,
      suggestions: suggestions ?? this.suggestions,
      failureInfo: failureInfo ?? this.failureInfo,
      successInfo: successInfo ?? this.successInfo,
    );
  }
}

class MessageSendStateLoading extends MessageSendState {
  const MessageSendStateLoading({
    super.recipients,
    super.suggestions,
    super.failureInfo,
    super.successInfo,
  });

  factory MessageSendStateLoading.fromState(MessageSendState state) =>
      MessageSendStateLoading(
        recipients: state.recipients,
        suggestions: state.suggestions,
      );

  @override
  MessageSendStateLoading copyWith({
    List<MessageUser>? recipients,
    List<MessageUser>? suggestions,
    String? failureInfo,
    String? successInfo,
  }) {
    return MessageSendStateLoading(
      recipients: recipients ?? this.recipients,
      suggestions: suggestions ?? this.suggestions,
      failureInfo: failureInfo ?? this.failureInfo,
      successInfo: successInfo ?? this.successInfo,
    );
  }
}

class MessageSendStateDidLoad extends MessageSendState {
  const MessageSendStateDidLoad({
    super.recipients,
    super.suggestions,
    super.failureInfo,
    super.successInfo,
  });

  factory MessageSendStateDidLoad.fromState(MessageSendState state) =>
      MessageSendStateDidLoad(
        recipients: state.recipients,
        suggestions: state.suggestions,
      );

  @override
  MessageSendStateDidLoad copyWith({
    List<MessageUser>? recipients,
    List<MessageUser>? suggestions,
    String? blocResponse,
    String? failureInfo,
    String? successInfo,
  }) {
    return MessageSendStateDidLoad(
      recipients: recipients ?? this.recipients,
      suggestions: suggestions ?? this.suggestions,
      failureInfo: failureInfo ?? this.failureInfo,
      successInfo: successInfo ?? this.successInfo,
    );
  }
}

class MessageSendStateError extends MessageSendState {
  const MessageSendStateError({
    super.recipients,
    super.suggestions,
    super.failureInfo,
    super.successInfo,
  });

  factory MessageSendStateError.fromState(MessageSendState state) =>
      MessageSendStateError(
        recipients: state.recipients,
        suggestions: state.suggestions,
        failureInfo: state.failureInfo,
      );

  @override
  MessageSendStateError copyWith({
    List<MessageUser>? recipients,
    List<MessageUser>? suggestions,
    String? failureInfo,
    String? successInfo,
  }) {
    return MessageSendStateError(
      recipients: recipients ?? this.recipients,
      suggestions: suggestions ?? this.suggestions,
      failureInfo: failureInfo ?? this.failureInfo,
      successInfo: successInfo ?? this.successInfo,
    );
  }
}
