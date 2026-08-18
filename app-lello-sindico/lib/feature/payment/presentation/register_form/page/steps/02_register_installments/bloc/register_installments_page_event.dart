import 'package:essentials/essentials.dart';

abstract class RegisterInstallmentsEvent {}

class RegisterInstallmentsEmptyEvent extends RegisterInstallmentsEvent {}

class RegisterInstallmentsLoadingEvent extends RegisterInstallmentsEvent {}

class RegisterInstallmentsSuccessEvent extends RegisterInstallmentsEvent {
  var value;
  RegisterInstallmentsSuccessEvent({required this.value});
}

class RegisterInstallmentsFailureEvent extends RegisterInstallmentsEvent {
  final Failure? error;
  RegisterInstallmentsFailureEvent({this.error});
}
