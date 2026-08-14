import 'package:essentials/essentials.dart';

abstract class ChangeOwnershipEvent extends Equatable {
  const ChangeOwnershipEvent();

  @override
  List<Object?> get props => [];
}

class ChangeOwnershipLoadingEvent extends ChangeOwnershipEvent {
  const ChangeOwnershipLoadingEvent();
}

class ChangeOwnershipLoadedEvent extends ChangeOwnershipEvent {
  final bool canChange;
  final String cantChangeMessage;

  const ChangeOwnershipLoadedEvent({
    required this.canChange,
    this.cantChangeMessage = "",
  });

  @override
  List<Object?> get props => [canChange, cantChangeMessage];
}

class ChangeOwnershipFailureEvent extends ChangeOwnershipEvent {
  final String error;

  const ChangeOwnershipFailureEvent({required this.error});

  @override
  List<Object?> get props => [error];
}

class ChangeOwnershipSuccessEvent extends ChangeOwnershipEvent {
  const ChangeOwnershipSuccessEvent();
}
