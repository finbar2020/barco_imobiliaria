import 'package:essentials/functional/failure.dart';

abstract class CheckTokenState {}

class CheckTokenInitial extends CheckTokenState {}

class CheckTokenLoading extends CheckTokenState {}

class CheckTokenSuccess extends CheckTokenState {
  final bool success;

  CheckTokenSuccess({required this.success});
}

class CheckTokenFailure extends CheckTokenState {
  final Failure? failure;

  CheckTokenFailure({required this.failure});
}

class ResendTokenLoading extends CheckTokenState {}

class ResendTokenSuccess extends CheckTokenState {
  final int id;

  ResendTokenSuccess({required this.id});
}

class ResendTokenFailure extends CheckTokenState {
  final String? failure;

  ResendTokenFailure({required this.failure});
}

class SendActionReasonLoading extends CheckTokenState {}

class SendActionReasonSuccess extends CheckTokenState {
  final bool success;

  SendActionReasonSuccess({required this.success});
}

class SendActionReasonFailure extends CheckTokenState {
  final Failure? failure;

  SendActionReasonFailure({required this.failure});
}

class UpdateInstallmentsLoading extends CheckTokenState {}

class UpdateInstallmentsSuccess extends CheckTokenState {
  final bool success;

  UpdateInstallmentsSuccess({required this.success});
}

class UpdateInstallmentsFailure extends CheckTokenState {
  final Failure? failure;

  UpdateInstallmentsFailure({required this.failure});
}
