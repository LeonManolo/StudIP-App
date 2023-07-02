import 'package:equatable/equatable.dart';
import 'package:messages_repository/messages_repository.dart';

enum MessageFilter {
  none('Alle Nachrichten'),
  unread('Ungelesene Nachrichten');

  const MessageFilter(this.description);
  final String description;
}

sealed class InboxMessageState extends Equatable {
  const InboxMessageState({
    this.inboxMessages = const [],
    this.currentOffset = 0,
    this.currentFilter = MessageFilter.none,
    this.successInfo = '',
    this.failureInfo = '',
    this.maxReached = false,
    this.paginationLoading = false,
  });

  final List<Message> inboxMessages;
  final int currentOffset;
  final MessageFilter currentFilter;
  final bool maxReached;
  final String successInfo;
  final String failureInfo;
  final bool paginationLoading;

  InboxMessageState copyWith({
    List<Message>? inboxMessages,
    String? successInfo,
    String? failureInfo,
    bool? maxReached,
    MessageFilter? currentFilter,
    bool? paginationLoading,
  });

  @override
  List<Object?> get props => [
        inboxMessages,
        currentOffset,
        currentFilter,
        successInfo,
        failureInfo,
        maxReached,
        paginationLoading
      ];
}

class InboxMessageStateInitial extends InboxMessageState {
  const InboxMessageStateInitial();

  @override
  InboxMessageStateInitial copyWith({
    List<Message>? inboxMessages,
    int? currentOffset,
    String? successInfo,
    String? failureInfo,
    MessageFilter? currentFilter,
    bool? maxReached,
    bool? paginationLoading,
  }) {
    return const InboxMessageStateInitial();
  }
}

class InboxMessageStateLoading extends InboxMessageState {
  const InboxMessageStateLoading({
    super.inboxMessages,
    super.currentOffset,
    super.currentFilter,
    super.successInfo,
    super.failureInfo,
    super.maxReached,
    super.paginationLoading,
  });

  factory InboxMessageStateLoading.fromState(InboxMessageState state) =>
      InboxMessageStateLoading(
        inboxMessages: state.inboxMessages,
        currentOffset: state.currentOffset,
        currentFilter: state.currentFilter,
        maxReached: state.maxReached,
        paginationLoading: state.paginationLoading,
      );

  @override
  InboxMessageStateLoading copyWith({
    List<Message>? inboxMessages,
    int? currentOffset,
    String? successInfo,
    String? failureInfo,
    MessageFilter? currentFilter,
    bool? maxReached,
    bool? paginationLoading,
  }) {
    return InboxMessageStateLoading(
      inboxMessages: inboxMessages ?? this.inboxMessages,
      currentOffset: currentOffset ?? this.currentOffset,
      currentFilter: currentFilter ?? this.currentFilter,
      maxReached: maxReached ?? this.maxReached,
      failureInfo: failureInfo ?? this.failureInfo,
      successInfo: successInfo ?? this.successInfo,
      paginationLoading: paginationLoading ?? this.paginationLoading,
    );
  }
}

class InboxMessageStateDidLoad extends InboxMessageState {
  const InboxMessageStateDidLoad({
    super.inboxMessages,
    super.currentOffset,
    super.currentFilter,
    super.successInfo,
    super.failureInfo,
    super.maxReached,
    super.paginationLoading,
  });

  factory InboxMessageStateDidLoad.fromState(InboxMessageState state) =>
      InboxMessageStateDidLoad(
        inboxMessages: state.inboxMessages,
        currentOffset: state.currentOffset,
        currentFilter: state.currentFilter,
        maxReached: state.maxReached,
        paginationLoading: state.paginationLoading,
      );

  @override
  InboxMessageStateDidLoad copyWith({
    List<Message>? inboxMessages,
    int? currentOffset,
    String? successInfo,
    String? failureInfo,
    MessageFilter? currentFilter,
    bool? maxReached,
    bool? paginationLoading,
  }) {
    return InboxMessageStateDidLoad(
      inboxMessages: inboxMessages ?? this.inboxMessages,
      currentOffset: currentOffset ?? this.currentOffset,
      currentFilter: currentFilter ?? this.currentFilter,
      maxReached: maxReached ?? this.maxReached,
      failureInfo: failureInfo ?? this.failureInfo,
      successInfo: successInfo ?? this.successInfo,
      paginationLoading: paginationLoading ?? this.paginationLoading,
    );
  }
}

class InboxMessageStateDeleteSucceed extends InboxMessageState {
  const InboxMessageStateDeleteSucceed({
    super.inboxMessages,
    super.currentOffset,
    super.currentFilter,
    super.successInfo,
    super.failureInfo,
    super.maxReached,
    super.paginationLoading,
  });

  factory InboxMessageStateDeleteSucceed.fromState(InboxMessageState state) =>
      InboxMessageStateDeleteSucceed(
        inboxMessages: state.inboxMessages,
        currentOffset: state.currentOffset,
        currentFilter: state.currentFilter,
        successInfo: state.successInfo,
        maxReached: state.maxReached,
        paginationLoading: state.paginationLoading,
      );

  @override
  InboxMessageStateDeleteSucceed copyWith({
    List<Message>? inboxMessages,
    int? currentOffset,
    String? blocResponse,
    MessageFilter? currentFilter,
    String? failureInfo,
    String? successInfo,
    bool? maxReached,
    bool? paginationLoading,
  }) {
    return InboxMessageStateDeleteSucceed(
      inboxMessages: inboxMessages ?? this.inboxMessages,
      currentOffset: currentOffset ?? this.currentOffset,
      currentFilter: currentFilter ?? this.currentFilter,
      failureInfo: failureInfo ?? this.failureInfo,
      successInfo: successInfo ?? this.successInfo,
      maxReached: maxReached ?? this.maxReached,
    );
  }
}

class InboxMessageStateDeleteError extends InboxMessageState {
  const InboxMessageStateDeleteError({
    super.inboxMessages,
    super.currentOffset,
    super.currentFilter,
    super.successInfo,
    super.failureInfo,
    super.maxReached,
    super.paginationLoading,
  });

  factory InboxMessageStateDeleteError.fromState(InboxMessageState state) =>
      InboxMessageStateDeleteError(
        inboxMessages: state.inboxMessages,
        currentOffset: state.currentOffset,
        currentFilter: state.currentFilter,
        failureInfo: state.failureInfo,
        maxReached: state.maxReached,
      );

  @override
  InboxMessageStateDeleteError copyWith({
    List<Message>? inboxMessages,
    int? currentOffset,
    MessageFilter? currentFilter,
    String? successInfo,
    String? failureInfo,
    bool? maxReached,
    bool? paginationLoading,
  }) {
    return InboxMessageStateDeleteError(
      inboxMessages: inboxMessages ?? this.inboxMessages,
      currentOffset: currentOffset ?? this.currentOffset,
      currentFilter: currentFilter ?? this.currentFilter,
      maxReached: maxReached ?? this.maxReached,
      failureInfo: failureInfo ?? this.failureInfo,
      successInfo: successInfo ?? this.successInfo,
      paginationLoading: paginationLoading ?? this.paginationLoading,
    );
  }
}

class InboxMessageStateError extends InboxMessageState {
  const InboxMessageStateError({
    super.inboxMessages,
    super.currentOffset,
    super.currentFilter,
    super.successInfo,
    super.failureInfo,
    super.maxReached,
    super.paginationLoading,
  });

  @override
  InboxMessageStateError copyWith({
    List<Message>? inboxMessages,
    int? currentOffset,
    String? successInfo,
    String? failureInfo,
    MessageFilter? currentFilter,
    bool? maxReached,
    bool? paginationLoading,
  }) {
    return InboxMessageStateError(
      inboxMessages: inboxMessages ?? this.inboxMessages,
      currentOffset: currentOffset ?? this.currentOffset,
      currentFilter: currentFilter ?? this.currentFilter,
      maxReached: maxReached ?? this.maxReached,
      failureInfo: failureInfo ?? this.failureInfo,
      successInfo: successInfo ?? this.successInfo,
      paginationLoading: paginationLoading ?? this.paginationLoading,
    );
  }
}
