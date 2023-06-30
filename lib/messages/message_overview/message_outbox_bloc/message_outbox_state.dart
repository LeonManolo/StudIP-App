import 'package:equatable/equatable.dart';
import 'package:messages_repository/messages_repository.dart';

sealed class OutboxMessageState extends Equatable {
  const OutboxMessageState({
    this.outboxMessages = const [],
    this.currentOffset = 0,
    this.blocResponse = '',
    this.maxReached = false,
    this.paginationLoading = false,
  });

  final List<Message> outboxMessages;
  final int currentOffset;
  final bool maxReached;
  final String blocResponse;
  final bool paginationLoading;

  OutboxMessageState copyWith({
    List<Message>? outboxMessages,
    int? currentOffset,
    String? blocResponse,
    bool? maxReached,
    bool? paginationLoading,
  });

  @override
  List<Object?> get props => [
        outboxMessages,
        currentOffset,
        blocResponse,
        maxReached,
        paginationLoading
      ];
}

class OutboxMessageStateInitial extends OutboxMessageState {
  const OutboxMessageStateInitial({
    super.blocResponse,
    super.currentOffset,
    super.maxReached,
    super.outboxMessages,
    super.paginationLoading,
  });

  @override
  OutboxMessageStateInitial copyWith({
    List<Message>? outboxMessages,
    int? currentOffset,
    String? blocResponse,
    bool? maxReached,
    bool? paginationLoading,
  }) {
    return OutboxMessageStateInitial(
      outboxMessages: outboxMessages ?? this.outboxMessages,
      currentOffset: currentOffset ?? this.currentOffset,
      blocResponse: blocResponse ?? this.blocResponse,
      maxReached: maxReached ?? this.maxReached,
      paginationLoading: paginationLoading ?? this.paginationLoading,
    );
  }

  @override
  List<Object?> get props => [
        outboxMessages,
        currentOffset,
        blocResponse,
        maxReached,
        paginationLoading
      ];
}

class OutboxMessageStateLoading extends OutboxMessageState {
  const OutboxMessageStateLoading({
    super.blocResponse,
    super.currentOffset,
    super.maxReached,
    super.outboxMessages,
    super.paginationLoading,
  });

  factory OutboxMessageStateLoading.fromState(OutboxMessageState state) =>
      OutboxMessageStateLoading(
        outboxMessages: state.outboxMessages,
        currentOffset: state.currentOffset,
        blocResponse: state.blocResponse,
        maxReached: state.maxReached,
        paginationLoading: state.paginationLoading,
      );

  @override
  OutboxMessageStateInitial copyWith({
    List<Message>? outboxMessages,
    int? currentOffset,
    String? blocResponse,
    bool? maxReached,
    bool? paginationLoading,
  }) {
    return OutboxMessageStateInitial(
      outboxMessages: outboxMessages ?? this.outboxMessages,
      currentOffset: currentOffset ?? this.currentOffset,
      blocResponse: blocResponse ?? this.blocResponse,
      maxReached: maxReached ?? this.maxReached,
      paginationLoading: paginationLoading ?? this.paginationLoading,
    );
  }

  @override
  List<Object?> get props => [
        outboxMessages,
        currentOffset,
        blocResponse,
        maxReached,
        paginationLoading
      ];
}

class OutboxMessageStateDidLoad extends OutboxMessageState {
  const OutboxMessageStateDidLoad({
    super.blocResponse,
    super.currentOffset,
    super.maxReached,
    super.outboxMessages,
    super.paginationLoading,
  });

  factory OutboxMessageStateDidLoad.fromState(OutboxMessageState state) =>
      OutboxMessageStateDidLoad(
        outboxMessages: state.outboxMessages,
        currentOffset: state.currentOffset,
        blocResponse: state.blocResponse,
        maxReached: state.maxReached,
        paginationLoading: state.paginationLoading,
      );

  @override
  OutboxMessageStateInitial copyWith({
    List<Message>? outboxMessages,
    int? currentOffset,
    String? blocResponse,
    bool? maxReached,
    bool? paginationLoading,
  }) {
    return OutboxMessageStateInitial(
      outboxMessages: outboxMessages ?? this.outboxMessages,
      currentOffset: currentOffset ?? this.currentOffset,
      blocResponse: blocResponse ?? this.blocResponse,
      maxReached: maxReached ?? this.maxReached,
      paginationLoading: paginationLoading ?? this.paginationLoading,
    );
  }

  @override
  List<Object?> get props => [
        outboxMessages,
        currentOffset,
        blocResponse,
        maxReached,
        paginationLoading
      ];
}

class OutboxMessageStateDeleteSucceed extends OutboxMessageState {
  const OutboxMessageStateDeleteSucceed({
    super.blocResponse,
    super.currentOffset,
    super.maxReached,
    super.outboxMessages,
    super.paginationLoading,
  });

  factory OutboxMessageStateDeleteSucceed.fromState(OutboxMessageState state) =>
      OutboxMessageStateDeleteSucceed(
        outboxMessages: state.outboxMessages,
        currentOffset: state.currentOffset,
        blocResponse: state.blocResponse,
        maxReached: state.maxReached,
        paginationLoading: state.paginationLoading,
      );

  @override
  OutboxMessageStateInitial copyWith({
    List<Message>? outboxMessages,
    int? currentOffset,
    String? blocResponse,
    bool? maxReached,
    bool? paginationLoading,
  }) {
    return OutboxMessageStateInitial(
      outboxMessages: outboxMessages ?? this.outboxMessages,
      currentOffset: currentOffset ?? this.currentOffset,
      blocResponse: blocResponse ?? this.blocResponse,
      maxReached: maxReached ?? this.maxReached,
      paginationLoading: paginationLoading ?? this.paginationLoading,
    );
  }

  @override
  List<Object?> get props => [
        outboxMessages,
        currentOffset,
        blocResponse,
        maxReached,
        paginationLoading
      ];
}

class OutboxMessageStateDeleteError extends OutboxMessageState {
  const OutboxMessageStateDeleteError({
    super.blocResponse,
    super.currentOffset,
    super.maxReached,
    super.outboxMessages,
    super.paginationLoading,
  });

  factory OutboxMessageStateDeleteError.fromState(OutboxMessageState state) =>
      OutboxMessageStateDeleteError(
        outboxMessages: state.outboxMessages,
        currentOffset: state.currentOffset,
        blocResponse: state.blocResponse,
        maxReached: state.maxReached,
        paginationLoading: state.paginationLoading,
      );

  @override
  OutboxMessageStateInitial copyWith({
    List<Message>? outboxMessages,
    int? currentOffset,
    String? blocResponse,
    bool? maxReached,
    bool? paginationLoading,
  }) {
    return OutboxMessageStateInitial(
      outboxMessages: outboxMessages ?? this.outboxMessages,
      currentOffset: currentOffset ?? this.currentOffset,
      blocResponse: blocResponse ?? this.blocResponse,
      maxReached: maxReached ?? this.maxReached,
      paginationLoading: paginationLoading ?? this.paginationLoading,
    );
  }

  @override
  List<Object?> get props => [
        outboxMessages,
        currentOffset,
        blocResponse,
        maxReached,
        paginationLoading
      ];
}

class OutboxMessageStateError extends OutboxMessageState {
  const OutboxMessageStateError({
    super.blocResponse,
    super.currentOffset,
    super.maxReached,
    super.outboxMessages,
    super.paginationLoading,
  });

  @override
  OutboxMessageStateInitial copyWith({
    List<Message>? outboxMessages,
    int? currentOffset,
    String? blocResponse,
    bool? maxReached,
    bool? paginationLoading,
  }) {
    return OutboxMessageStateInitial(
      outboxMessages: outboxMessages ?? this.outboxMessages,
      currentOffset: currentOffset ?? this.currentOffset,
      blocResponse: blocResponse ?? this.blocResponse,
      maxReached: maxReached ?? this.maxReached,
      paginationLoading: paginationLoading ?? this.paginationLoading,
    );
  }

  @override
  List<Object?> get props => [
        outboxMessages,
        currentOffset,
        blocResponse,
        maxReached,
        paginationLoading
      ];
}
