part of shared_features;

abstract class CodeValidationState extends Equatable {
  const CodeValidationState();

  @override
  List<Object?> get props => [];
}

class CodeValidationEmptyState extends CodeValidationState {
  const CodeValidationEmptyState();
}

class CodeValidationValidatingState extends CodeValidationState {
  const CodeValidationValidatingState();
}

class CodeValidationSucceededState extends CodeValidationState {
  final CodeValidation validation;
  const CodeValidationSucceededState({
    required this.validation,
  });

  @override
  List<Object?> get props => [validation];
}

class CodeValidationResendState extends CodeValidationState {
  final CodeValidation validation;
  const CodeValidationResendState({
    required this.validation,
  });

  @override
  List<Object?> get props => [validation];
}

class CodeValidationFailedState extends CodeValidationState {
  final Failure error;
  const CodeValidationFailedState({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
