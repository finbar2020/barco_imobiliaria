part of shared_features;

abstract class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object?> get props => [];
}

class RegistrationEmptyState extends RegistrationState {
  const RegistrationEmptyState();
}

class RegistrationLoadingState extends RegistrationState {
  const RegistrationLoadingState();
}

class RegistrationSucceededState extends RegistrationState {
  const RegistrationSucceededState();
}

class RegistrationCodeRequestLoadingState extends RegistrationState {
  const RegistrationCodeRequestLoadingState();
}

class RegistrationCodeRequestFailedState extends RegistrationState {
  final Failure error;

  const RegistrationCodeRequestFailedState({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}

class RegistrationRequestMyUserFailedState extends RegistrationState {
  final Failure error;

  const RegistrationRequestMyUserFailedState({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}

class RegistrationRequestMyUserLoadingState extends RegistrationState {
  final String? loadingMessage;
  const RegistrationRequestMyUserLoadingState({
    this.loadingMessage,
  });

  @override
  List<Object?> get props => [loadingMessage];
}

class RegistrationRequestMyUserSucceededState extends RegistrationState {
  final CodeData codeData;
  final String selectedValue;
  final CodeValidationSource? type;
  const RegistrationRequestMyUserSucceededState({
    required this.codeData,
    required this.selectedValue,
    this.type,
  });

  @override
  List<Object?> get props => [codeData, selectedValue, type];
}

class RegistrationCodeRequestSucceededState extends RegistrationState {
  final CodeRequest codeRequest;
  const RegistrationCodeRequestSucceededState({
    required this.codeRequest,
  });

  @override
  List<Object?> get props => [codeRequest];
}

class RegistrationFailedState extends RegistrationState {
  final Failure error;
  const RegistrationFailedState({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}

class RegistrationAuthFailedState extends RegistrationState {
  final Failure error;
  const RegistrationAuthFailedState({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
