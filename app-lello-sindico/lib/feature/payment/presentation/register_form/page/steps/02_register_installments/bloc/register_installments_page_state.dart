import 'package:essentials/essentials.dart';

abstract class RegisterInstallmentsState extends Equatable {
  const RegisterInstallmentsState();

  @override
  List<Object?> get props => [];
}

class RegisterInstallmentsEmptyState extends RegisterInstallmentsState {
  const RegisterInstallmentsEmptyState();
}

class RegisterInstallmentsLoadingState extends RegisterInstallmentsState {
  const RegisterInstallmentsLoadingState();
}

class RegisterInstallmentsSuccessState extends RegisterInstallmentsState {
  final dynamic value;

  const RegisterInstallmentsSuccessState({required this.value});

  @override
  List<Object?> get props => [value];
}

class RegisterInstallmentsFailureState extends RegisterInstallmentsState {
  final Failure? error;

  const RegisterInstallmentsFailureState({this.error});

  @override
  List<Object?> get props => [error];
}
