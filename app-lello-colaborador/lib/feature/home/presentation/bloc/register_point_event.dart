import 'package:essentials/essentials.dart';

abstract class RegisterPointEvent extends Equatable {
  const RegisterPointEvent();

  @override
  List<Object?> get props => [];
}

class StartRegisterPointEvent extends RegisterPointEvent {
  const StartRegisterPointEvent();
}

class RegisterPointSuccessEvent extends RegisterPointEvent {
  const RegisterPointSuccessEvent();
}

class RegisterPointFailureEvent extends RegisterPointEvent {
  final String message;

  const RegisterPointFailureEvent({required this.message});

  @override
  List<Object?> get props => [message];
}

class NoLocationPermissionEvent extends RegisterPointEvent {
  const NoLocationPermissionEvent();
}

class OutOfRangeEvent extends RegisterPointEvent {
  const OutOfRangeEvent();
}

class WorkLeaveEvent extends RegisterPointEvent {
  final String description;

  const WorkLeaveEvent({
    required this.description,
  });

  @override
  List<Object?> get props => [description];
}

class OfflineFailureEvent extends RegisterPointEvent {
  const OfflineFailureEvent();
}

class DeviceTypeFailureEvent extends RegisterPointEvent {
  final bool onlyTablet;
  final bool onlyPhone;

  const DeviceTypeFailureEvent({
    this.onlyTablet = false,
    this.onlyPhone = false,
  });

  @override
  List<Object?> get props => [onlyTablet, onlyPhone];
}
