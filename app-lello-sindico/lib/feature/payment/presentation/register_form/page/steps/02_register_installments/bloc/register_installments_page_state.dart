import 'package:essentials/essentials.dart';

abstract class RegisterInstallmentsState {}

class RegisterInstallmentsEmptyState extends RegisterInstallmentsState {}

class RegisterInstallmentsLoadingState extends RegisterInstallmentsState {}

class RegisterInstallmentsSuccessState extends RegisterInstallmentsState {
  var value;
  RegisterInstallmentsSuccessState({required this.value});
}

class RegisterInstallmentsFailureState extends RegisterInstallmentsState {
  final Failure? error;
  RegisterInstallmentsFailureState({this.error});
}
