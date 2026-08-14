part of shared_features;

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object?> get props => [];
}

class RegistrationEmptyEvent extends RegistrationEvent {
  const RegistrationEmptyEvent();
}

class RegistrationLoadingEvent extends RegistrationEvent {
  final String? loadingMessage;
  const RegistrationLoadingEvent({
    this.loadingMessage,
  });

  @override
  List<Object?> get props => [loadingMessage];
}

class RegistrationSucceededEvent extends RegistrationEvent {
  const RegistrationSucceededEvent();
}

class RegistrationCodeRequestLoadingEvent extends RegistrationEvent {
  final String loadingMessage;
  const RegistrationCodeRequestLoadingEvent({
    required this.loadingMessage,
  });

  @override
  List<Object?> get props => [loadingMessage];
}

class RegistrationCodeRequestFailedEvent extends RegistrationEvent {
  final Failure error;

  const RegistrationCodeRequestFailedEvent({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}

class RegistrationRequestMyUserFailedEvent extends RegistrationEvent {
  final Failure error;

  const RegistrationRequestMyUserFailedEvent({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}

class RegistrationRequestMyUserLoadingEvent extends RegistrationEvent {
  final String cpf;
  final String? loadingMessage;
  const RegistrationRequestMyUserLoadingEvent({
    required this.cpf,
    this.loadingMessage,
  });

  @override
  List<Object?> get props => [cpf, loadingMessage];
}

class RegistrationRequestMyUserSucceededEvent extends RegistrationEvent {
  final CodeData codeData;
  final String selectedValue;
  final CodeValidationSource? type;
  const RegistrationRequestMyUserSucceededEvent({
    required this.codeData,
    required this.selectedValue,
    this.type,
  });

  @override
  List<Object?> get props => [codeData, selectedValue, type];
}

class RegistrationCodeRequestSucceededEvent extends RegistrationEvent {
  final CodeRequest codeRequest;
  const RegistrationCodeRequestSucceededEvent({
    required this.codeRequest,
  });

  @override
  List<Object?> get props => [codeRequest];
}

class RegistrationFailedEvent extends RegistrationEvent {
  final Failure error;
  const RegistrationFailedEvent({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}

class RegistrationAuthFailedEvent extends RegistrationEvent {
  final Failure error;
  const RegistrationAuthFailedEvent({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
