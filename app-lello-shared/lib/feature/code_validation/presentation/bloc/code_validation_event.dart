part of shared_features;

abstract class CodeValidationEvent extends Equatable {
  const CodeValidationEvent();

  @override
  List<Object?> get props => [];
}

class CodeValidationEmptyEvent extends CodeValidationEvent {
  const CodeValidationEmptyEvent();
}

class CodeValidationLoadingEvent extends CodeValidationEvent {
  const CodeValidationLoadingEvent();
}

class CodeValidationSucceededEvent extends CodeValidationEvent {
  final CodeValidation validation;
  const CodeValidationSucceededEvent({
    required this.validation,
  });

  @override
  List<Object?> get props => [validation];
}

class CodeValidationResendEvent extends CodeValidationEvent {
  final CodeValidation validation;
  const CodeValidationResendEvent({
    required this.validation,
  });

  @override
  List<Object?> get props => [validation];
}

class CodeValidationFailedEvent extends CodeValidationEvent {
  final Failure error;
  const CodeValidationFailedEvent({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
