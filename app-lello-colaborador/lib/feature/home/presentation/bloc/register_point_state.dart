import 'package:essentials/essentials.dart';

abstract class RegisterPointState extends Equatable {
  const RegisterPointState();

  @override
  List<Object?> get props => [];
}

class RegisterPointInitialState extends RegisterPointState {
  const RegisterPointInitialState();
}

class RegisterPointFailureState extends RegisterPointState {
  final String message;

  const RegisterPointFailureState({required this.message});

  @override
  List<Object?> get props => [message];
}

class NoLocationPermissionState extends RegisterPointState {
  const NoLocationPermissionState();
}

class OutOfRangeState extends RegisterPointState {
  const OutOfRangeState();
}

class StartRegisterPointState extends RegisterPointState {
  const StartRegisterPointState();
}

class RegisterPointFaceCaptureState extends RegisterPointState {
  const RegisterPointFaceCaptureState();
}

class WorkLeaveState extends RegisterPointState {
  final String description;

  const WorkLeaveState({
    required this.description,
  });

  @override
  List<Object?> get props => [description];
}

class OfflineFailureState extends RegisterPointState {
  const OfflineFailureState();
}

class DeviceTypeFailureState extends RegisterPointState {
  final bool onlyTablet;
  final bool onlyPhone;

  const DeviceTypeFailureState({
    this.onlyTablet = false,
    this.onlyPhone = false,
  });

  @override
  List<Object?> get props => [onlyTablet, onlyPhone];
}
