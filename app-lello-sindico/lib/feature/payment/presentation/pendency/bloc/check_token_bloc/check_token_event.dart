import 'package:essentials/essentials.dart';

abstract class CheckTokenEvent extends Equatable {
  const CheckTokenEvent();

  @override
  List<Object?> get props => [];
}

class CheckTokenInitialEvent extends CheckTokenEvent {
  const CheckTokenInitialEvent();
}

class CheckTokenLoadingEvent extends CheckTokenEvent {
  const CheckTokenLoadingEvent();
}

class CheckTokenSuccessEvent extends CheckTokenEvent {
  final bool success;

  const CheckTokenSuccessEvent({required this.success});

  @override
  List<Object?> get props => [success];
}

class CheckTokenFailureEvent extends CheckTokenEvent {
  final Failure? failure;

  const CheckTokenFailureEvent({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class ResendTokenLoadingEvent extends CheckTokenEvent {
  const ResendTokenLoadingEvent();
}

class ResendTokenSuccessEvent extends CheckTokenEvent {
  final int id;

  const ResendTokenSuccessEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class ResendTokenFailureEvent extends CheckTokenEvent {
  final String? failure;

  const ResendTokenFailureEvent({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class SendActionReasonLoadingEvent extends CheckTokenEvent {
  const SendActionReasonLoadingEvent();
}

class SendActionReasonSuccessEvent extends CheckTokenEvent {
  final bool success;

  const SendActionReasonSuccessEvent({required this.success});

  @override
  List<Object?> get props => [success];
}

class SendActionReasonFailureEvent extends CheckTokenEvent {
  final Failure? failure;

  const SendActionReasonFailureEvent({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class UpdateInstallmentsLoadingEvent extends CheckTokenEvent {
  const UpdateInstallmentsLoadingEvent();
}

class UpdateInstallmentsSuccessEvent extends CheckTokenEvent {
  final bool success;

  const UpdateInstallmentsSuccessEvent({required this.success});

  @override
  List<Object?> get props => [success];
}

class UpdateInstallmentsFailureEvent extends CheckTokenEvent {
  final Failure? failure;

  const UpdateInstallmentsFailureEvent({required this.failure});

  @override
  List<Object?> get props => [failure];
}
