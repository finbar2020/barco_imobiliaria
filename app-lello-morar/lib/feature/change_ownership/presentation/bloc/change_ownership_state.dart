import 'package:essentials/essentials.dart';

abstract class ChangeOwnershipState extends Equatable {
  const ChangeOwnershipState();

  @override
  List<Object?> get props => [];
}

class ChangeOwnershipInitialState extends ChangeOwnershipState {
  const ChangeOwnershipInitialState();
}

class ChangeOwnershipLoadingState extends ChangeOwnershipState {
  const ChangeOwnershipLoadingState();
}

class ChangeOwnershipLoadedState extends ChangeOwnershipState {
  final bool canChange;
  final String cantChangeMessage;

  const ChangeOwnershipLoadedState({
    required this.canChange,
    this.cantChangeMessage = "",
  });

  @override
  List<Object?> get props => [canChange, cantChangeMessage];
}

class ChangeOwnershipFailureState extends ChangeOwnershipState {
  final String errorMessageKey;

  const ChangeOwnershipFailureState({required this.errorMessageKey});

  @override
  List<Object?> get props => [errorMessageKey];
}

class ChangeOwnershipSuccessState extends ChangeOwnershipState {
  const ChangeOwnershipSuccessState();
}
