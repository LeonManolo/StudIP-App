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
    this.blocResponse = '',
    this.maxReached = false,
    this.paginationLoading = false,
  });

  final List<Message> inboxMessages;
  final int currentOffset;
  final MessageFilter currentFilter;
  final bool maxReached;
  final String blocResponse;
  final bool paginationLoading;

  InboxMessageState copyWith({
    List<Message>? inboxMessages,
    int? currentOffset,
    String? blocResponse,
    bool? maxReached,
    MessageFilter? currentFilter,
    bool? paginationLoading,
  });

  @override
  List<Object?> get props => [
        inboxMessages,
        currentOffset,
        currentFilter,
        blocResponse,
        maxReached,
        paginationLoading
      ];
}

class InboxMessageStateInitial extends InboxMessageState {
  const InboxMessageStateInitial({
    super.blocResponse,
    super.currentOffset,
    super.maxReached,
    super.currentFilter,
    super.inboxMessages,
    super.paginationLoading,
  });

  @override
  InboxMessageStateInitial copyWith({
    List<Message>? inboxMessages,
    int? currentOffset,
    String? blocResponse,
    MessageFilter? currentFilter,
    bool? maxReached,
    bool? paginationLoading,
  }) {
    return InboxMessageStateInitial(
      inboxMessages: inboxMessages ?? this.inboxMessages,
      currentOffset: currentOffset ?? this.currentOffset,
      blocResponse: blocResponse ?? this.blocResponse,
      currentFilter: currentFilter ?? this.currentFilter,
      maxReached: maxReached ?? this.maxReached,
      paginationLoading: paginationLoading ?? this.paginationLoading,
    );
  }

  @override
  List<Object?> get props => [
        inboxMessages,
        currentOffset,
        blocResponse,
        currentFilter,
        maxReached,
        paginationLoading
      ];
}

class InboxMessageStateLoading extends InboxMessageState {
  const InboxMessageStateLoading({
    super.blocResponse,
    super.currentOffset,
    super.maxReached,
    super.currentFilter,
    super.inboxMessages,
    super.paginationLoading,
  });

  factory InboxMessageStateLoading.fromState(InboxMessageState state) =>
      InboxMessageStateLoading(
        inboxMessages: state.inboxMessages,
        currentOffset: state.currentOffset,
        blocResponse: state.blocResponse,
        currentFilter: state.currentFilter,
        maxReached: state.maxReached,
        paginationLoading: state.paginationLoading,
      );

  @override
  InboxMessageStateLoading copyWith({
    List<Message>? inboxMessages,
    int? currentOffset,
    String? blocResponse,
    MessageFilter? currentFilter,
    bool? maxReached,
    bool? paginationLoading,
  }) {
    return InboxMessageStateLoading(
      inboxMessages: inboxMessages ?? this.inboxMessages,
      currentOffset: currentOffset ?? this.currentOffset,
      blocResponse: blocResponse ?? this.blocResponse,
      currentFilter: currentFilter ?? this.currentFilter,
      maxReached: maxReached ?? this.maxReached,
      paginationLoading: paginationLoading ?? this.paginationLoading,
    );
  }

  @override
  List<Object?> get props => [
        inboxMessages,
        currentOffset,
        blocResponse,
        currentFilter,
        maxReached,
        paginationLoading
      ];
}

class InboxMessageStateDidLoad extends InboxMessageState {
  const InboxMessageStateDidLoad({
    super.blocResponse,
    super.currentOffset,
    super.maxReached,
    super.inboxMessages,
    super.currentFilter,
    super.paginationLoading,
  });

  factory InboxMessageStateDidLoad.fromState(InboxMessageState state) =>
      InboxMessageStateDidLoad(
        inboxMessages: state.inboxMessages,
        currentOffset: state.currentOffset,
        blocResponse: state.blocResponse,
        currentFilter: state.currentFilter,
        maxReached: state.maxReached,
        paginationLoading: state.paginationLoading,
      );

  @override
  InboxMessageStateDidLoad copyWith({
    List<Message>? inboxMessages,
    int? currentOffset,
    String? blocResponse,
    MessageFilter? currentFilter,
    bool? maxReached,
    bool? paginationLoading,
  }) {
    return InboxMessageStateDidLoad(
      inboxMessages: inboxMessages ?? this.inboxMessages,
      currentOffset: currentOffset ?? this.currentOffset,
      blocResponse: blocResponse ?? this.blocResponse,
      currentFilter: currentFilter ?? this.currentFilter,
      maxReached: maxReached ?? this.maxReached,
      paginationLoading: paginationLoading ?? this.paginationLoading,
    );
  }

  @override
  List<Object?> get props => [
        inboxMessages,
        currentOffset,
        blocResponse,
        currentFilter,
        maxReached,
        paginationLoading
      ];
}

class InboxMessageStateDeleteSucceed extends InboxMessageState {
  const InboxMessageStateDeleteSucceed({
    super.blocResponse,
    super.currentOffset,
    super.maxReached,
    super.currentFilter,
    super.inboxMessages,
    super.paginationLoading,
  });

  factory InboxMessageStateDeleteSucceed.fromState(InboxMessageState state) =>
      InboxMessageStateDeleteSucceed(
        inboxMessages: state.inboxMessages,
        currentOffset: state.currentOffset,
        blocResponse: state.blocResponse,
        currentFilter: state.currentFilter,
        maxReached: state.maxReached,
        paginationLoading: state.paginationLoading,
      );

  @override
  InboxMessageStateDeleteSucceed copyWith({
    List<Message>? inboxMessages,
    int? currentOffset,
    String? blocResponse,
    MessageFilter? currentFilter,
    bool? maxReached,
    bool? paginationLoading,
  }) {
    return InboxMessageStateDeleteSucceed(
      inboxMessages: inboxMessages ?? this.inboxMessages,
      currentOffset: currentOffset ?? this.currentOffset,
      blocResponse: blocResponse ?? this.blocResponse,
      currentFilter: currentFilter ?? this.currentFilter,
      maxReached: maxReached ?? this.maxReached,
      paginationLoading: paginationLoading ?? this.paginationLoading,
    );
  }

  @override
  List<Object?> get props => [
        inboxMessages,
        currentOffset,
        blocResponse,
        currentFilter,
        maxReached,
        paginationLoading
      ];
}

class InboxMessageStateDeleteError extends InboxMessageState {
  const InboxMessageStateDeleteError({
    super.blocResponse,
    super.currentOffset,
    super.maxReached,
    super.currentFilter,
    super.inboxMessages,
    super.paginationLoading,
  });

  factory InboxMessageStateDeleteError.fromState(InboxMessageState state) =>
      InboxMessageStateDeleteError(
        inboxMessages: state.inboxMessages,
        currentOffset: state.currentOffset,
        blocResponse: state.blocResponse,
        currentFilter: state.currentFilter,
        maxReached: state.maxReached,
        paginationLoading: state.paginationLoading,
      );

  @override
  InboxMessageStateDeleteError copyWith({
    List<Message>? inboxMessages,
    int? currentOffset,
    String? blocResponse,
    MessageFilter? currentFilter,
    bool? maxReached,
    bool? paginationLoading,
  }) {
    return InboxMessageStateDeleteError(
      inboxMessages: inboxMessages ?? this.inboxMessages,
      currentOffset: currentOffset ?? this.currentOffset,
      blocResponse: blocResponse ?? this.blocResponse,
      currentFilter: currentFilter ?? this.currentFilter,
      maxReached: maxReached ?? this.maxReached,
      paginationLoading: paginationLoading ?? this.paginationLoading,
    );
  }

  @override
  List<Object?> get props => [
        inboxMessages,
        currentOffset,
        blocResponse,
        currentFilter,
        maxReached,
        paginationLoading
      ];
}

class InboxMessageStateError extends InboxMessageState {
  const InboxMessageStateError({
    super.blocResponse,
    super.currentOffset,
    super.maxReached,
    super.currentFilter,
    super.inboxMessages,
    super.paginationLoading,
  });

  @override
  InboxMessageStateError copyWith({
    List<Message>? inboxMessages,
    int? currentOffset,
    String? blocResponse,
    MessageFilter? currentFilter,
    bool? maxReached,
    bool? paginationLoading,
  }) {
    return InboxMessageStateError(
      inboxMessages: inboxMessages ?? this.inboxMessages,
      currentOffset: currentOffset ?? this.currentOffset,
      blocResponse: blocResponse ?? this.blocResponse,
      currentFilter: currentFilter ?? this.currentFilter,
      maxReached: maxReached ?? this.maxReached,
      paginationLoading: paginationLoading ?? this.paginationLoading,
    );
  }

  @override
  List<Object?> get props => [
        inboxMessages,
        currentOffset,
        blocResponse,
        currentFilter,
        maxReached,
        paginationLoading
      ];
}
