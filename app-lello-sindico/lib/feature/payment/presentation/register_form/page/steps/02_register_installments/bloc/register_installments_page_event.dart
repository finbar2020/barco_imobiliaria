import 'package:essentials/essentials.dart';

abstract class RegisterInstallmentsEvent extends Equatable {
  const RegisterInstallmentsEvent();

  @override
  List<Object?> get props => [];
}

class RegisterInstallmentsEmptyEvent extends RegisterInstallmentsEvent {
  const RegisterInstallmentsEmptyEvent();
}

class RegisterInstallmentsLoadingEvent extends RegisterInstallmentsEvent {
  const RegisterInstallmentsLoadingEvent();
}

class RegisterInstallmentsSuccessEvent extends RegisterInstallmentsEvent {
  final dynamic value;

  const RegisterInstallmentsSuccessEvent({required this.value});

  @override
  List<Object?> get props => [value];
}

class RegisterInstallmentsFailureEvent extends RegisterInstallmentsEvent {
  final Failure? error;

  const RegisterInstallmentsFailureEvent({this.error});

  @override
  List<Object?> get props => [error];
}
