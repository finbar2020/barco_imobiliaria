import 'package:essentials/functional/failure.dart';

abstract class CheckTokenEvent {}

class CheckTokenInitialEvent extends CheckTokenEvent {}

class CheckTokenLoadingEvent extends CheckTokenEvent {}

class CheckTokenSuccessEvent extends CheckTokenEvent {
  final bool success;

  CheckTokenSuccessEvent({required this.success});
}

class CheckTokenFailureEvent extends CheckTokenEvent {
  final Failure? failure;

  CheckTokenFailureEvent({required this.failure});
}

class ResendTokenLoadingEvent extends CheckTokenEvent {}

class ResendTokenSuccessEvent extends CheckTokenEvent {
  final int id;

  ResendTokenSuccessEvent({required this.id});
}

class ResendTokenFailureEvent extends CheckTokenEvent {
  final String? failure;

  ResendTokenFailureEvent({required this.failure});
}

class SendActionReasonLoadingEvent extends CheckTokenEvent {}

class SendActionReasonSuccessEvent extends CheckTokenEvent {
  final bool success;

  SendActionReasonSuccessEvent({required this.success});
}

class SendActionReasonFailureEvent extends CheckTokenEvent {
  final Failure? failure;

  SendActionReasonFailureEvent({required this.failure});
}

class UpdateInstallmentsLoadingEvent extends CheckTokenEvent {}

class UpdateInstallmentsSuccessEvent extends CheckTokenEvent {
  final bool success;

  UpdateInstallmentsSuccessEvent({required this.success});
}

class UpdateInstallmentsFailureEvent extends CheckTokenEvent {
  final Failure? failure;

  UpdateInstallmentsFailureEvent({required this.failure});
}
