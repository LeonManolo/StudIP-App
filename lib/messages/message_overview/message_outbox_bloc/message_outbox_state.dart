import 'package:equatable/equatable.dart';
import 'package:messages_repository/messages_repository.dart';

sealed class OutboxMessageState extends Equatable {
  const OutboxMessageState({
    this.outboxMessages = const [],
    this.currentOffset = 0,
    this.successInfo = '',
    this.failureInfo = '',
    this.maxReached = false,
    this.paginationLoading = false,
  });

  final List<Message> outboxMessages;
  final int currentOffset;
  final bool maxReached;
  final String successInfo;
  final String failureInfo;
  final bool paginationLoading;

  OutboxMessageState copyWith({
    List<Message>? outboxMessages,
    int? currentOffset,
    String? successInfo,
    String? failureInfo,
    bool? maxReached,
    bool? paginationLoading,
  });

  @override
  List<Object?> get props => [
        outboxMessages,
        currentOffset,
        successInfo,
        failureInfo,
        maxReached,
        paginationLoading
      ];
}

class OutboxMessageStateInitial extends OutboxMessageState {
  const OutboxMessageStateInitial();

  @override
  OutboxMessageStateInitial copyWith({
    List<Message>? outboxMessages,
    int? currentOffset,
    String? successInfo,
    String? failureInfo,
    bool? maxReached,
    bool? paginationLoading,
  }) {
    return const OutboxMessageStateInitial();
  }
}

class OutboxMessageStateLoading extends OutboxMessageState {
  const OutboxMessageStateLoading({
    super.outboxMessages,
    super.failureInfo,
    super.successInfo,
    super.currentOffset,
    super.maxReached,
    super.paginationLoading,
  });

  factory OutboxMessageStateLoading.fromState(OutboxMessageState state) =>
      OutboxMessageStateLoading(
        outboxMessages: state.outboxMessages,
      );

  @override
  OutboxMessageStateLoading copyWith({
    List<Message>? outboxMessages,
    int? currentOffset,
    String? successInfo,
    String? failureInfo,
    bool? maxReached,
    bool? paginationLoading,
  }) {
    return OutboxMessageStateLoading(   
      outboxMessages: outboxMessages ?? this.outboxMessages,
      failureInfo: failureInfo ?? this.failureInfo,
      successInfo: successInfo ?? this.successInfo,
      currentOffset: currentOffset ?? this.currentOffset,
      maxReached: maxReached ?? this.maxReached,
      paginationLoading: paginationLoading ?? this.paginationLoading,
    );
  }
}

class OutboxMessageStateDidLoad extends OutboxMessageState {
  const OutboxMessageStateDidLoad({
    super.outboxMessages,
    super.failureInfo,
    super.successInfo,
    super.currentOffset,
    super.maxReached,
    super.paginationLoading,
  });

  factory OutboxMessageStateDidLoad.fromState(OutboxMessageState state) =>
      OutboxMessageStateDidLoad(
        outboxMessages: state.outboxMessages,
        currentOffset: state.currentOffset,
        maxReached: state.maxReached,
        paginationLoading: state.paginationLoading,
      );

  @override
  OutboxMessageStateDidLoad copyWith({
    List<Message>? outboxMessages,
    int? currentOffset,
    String? blocResponse,
    String? successInfo,
    String? failureInfo,
    bool? maxReached,
    bool? paginationLoading,
  }) {
    return OutboxMessageStateDidLoad(
      outboxMessages: outboxMessages ?? this.outboxMessages,
      failureInfo: failureInfo ?? this.failureInfo,
      successInfo: successInfo ?? this.successInfo,
      currentOffset: currentOffset ?? this.currentOffset,
      maxReached: maxReached ?? this.maxReached,
      paginationLoading: paginationLoading ?? this.paginationLoading,
    );
  }
}

class OutboxMessageStateDeleteSucceed extends OutboxMessageState {
  const OutboxMessageStateDeleteSucceed({
    super.outboxMessages,
    super.failureInfo,
    super.successInfo,
    super.currentOffset,
    super.maxReached,
    super.paginationLoading,
  });

  factory OutboxMessageStateDeleteSucceed.fromState(OutboxMessageState state) =>
      OutboxMessageStateDeleteSucceed(
        outboxMessages: state.outboxMessages,
        currentOffset: state.currentOffset,
        successInfo: state.successInfo,
        maxReached: state.maxReached,
        paginationLoading: state.paginationLoading,
      );

  @override
  OutboxMessageStateDeleteSucceed copyWith({
    List<Message>? outboxMessages,
    int? currentOffset,
    String? failureInfo,
    String? successInfo,
    bool? maxReached,
    bool? paginationLoading,
  }) {
    return OutboxMessageStateDeleteSucceed(
      outboxMessages: outboxMessages ?? this.outboxMessages,
      failureInfo: failureInfo ?? this.failureInfo,
      successInfo: successInfo ?? this.successInfo,
      currentOffset: currentOffset ?? this.currentOffset,
      maxReached: maxReached ?? this.maxReached,
      paginationLoading: paginationLoading ?? this.paginationLoading,
    );
  }
}

class OutboxMessageStateDeleteError extends OutboxMessageState {
  const OutboxMessageStateDeleteError({
    super.outboxMessages,
    super.failureInfo,
    super.successInfo,
    super.currentOffset,
    super.maxReached,
    super.paginationLoading,
  });

  factory OutboxMessageStateDeleteError.fromState(OutboxMessageState state) =>
      OutboxMessageStateDeleteError(
        outboxMessages: state.outboxMessages,
        currentOffset: state.currentOffset,
        failureInfo: state.failureInfo,
        maxReached: state.maxReached,
        paginationLoading: state.paginationLoading,
      );

  @override
  OutboxMessageStateDeleteError copyWith({
    List<Message>? outboxMessages,
    int? currentOffset,
    String? successInfo,
    String? failureInfo,
    bool? maxReached,
    bool? paginationLoading,
  }) {
    return OutboxMessageStateDeleteError(
      outboxMessages: outboxMessages ?? this.outboxMessages,
      failureInfo: failureInfo ?? this.failureInfo,
      successInfo: successInfo ?? this.successInfo,
      currentOffset: currentOffset ?? this.currentOffset,
      maxReached: maxReached ?? this.maxReached,
      paginationLoading: paginationLoading ?? this.paginationLoading,
    );
  }
}

class OutboxMessageStateError extends OutboxMessageState {
  const OutboxMessageStateError({
    super.outboxMessages,
    super.failureInfo,
    super.successInfo,
    super.currentOffset,
    super.maxReached,
    super.paginationLoading,
  });

  @override
  OutboxMessageStateError copyWith({
    List<Message>? outboxMessages,
    int? currentOffset,
    String? successInfo,
    String? failureInfo,
    bool? maxReached,
    bool? paginationLoading,
  }) {
    return OutboxMessageStateError(
      outboxMessages: outboxMessages ?? this.outboxMessages,
      failureInfo: failureInfo ?? this.failureInfo,
      successInfo: successInfo ?? this.successInfo,
      currentOffset: currentOffset ?? this.currentOffset,
      maxReached: maxReached ?? this.maxReached,
      paginationLoading: paginationLoading ?? this.paginationLoading,
    );
  }
}
