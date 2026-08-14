import 'package:equatable/equatable.dart';
import 'package:morar/feature/session/domain/entity/session.dart';
import 'package:morar/feature/vehicles/domain/entity/vehicles.dart';

abstract class VehicleEvent extends Equatable {
  const VehicleEvent();

  @override
  List<Object?> get props => [];
}

class VehicleIsEmptyEvent extends VehicleEvent {
  const VehicleIsEmptyEvent();
}

class LoadingInProgressEvent extends VehicleEvent {
  const LoadingInProgressEvent();
}

class LoadingInProgressDataEvent extends VehicleEvent {
  const LoadingInProgressDataEvent();
}

class VehicleLoadingUpdateInProgressEvent extends VehicleEvent {
  const VehicleLoadingUpdateInProgressEvent();
}

class VehicleAddingFailedEvent extends VehicleEvent {
  final String error;
  final String? message;

  const VehicleAddingFailedEvent({required this.error, this.message});

  @override
  List<Object?> get props => [error, message];
}

class VehicleAddSuccessEvent extends VehicleEvent {
  final List<Vehicle> vehicles;

  const VehicleAddSuccessEvent({required this.vehicles});

  @override
  List<Object?> get props => [vehicles];
}

class VehicleLoadingFailedEvent extends VehicleEvent {
  final String error;

  const VehicleLoadingFailedEvent({required this.error});

  @override
  List<Object?> get props => [error];
}

class VehicleLoadedDataEvent extends VehicleEvent {
  final List<Vehicle> vehicles;
  final Session session;

  const VehicleLoadedDataEvent({
    required this.vehicles,
    required this.session,
  });

  @override
  List<Object?> get props => [vehicles, session];
}

class UpdateVehicleEvent extends VehicleEvent {
  const UpdateVehicleEvent();
}

class VehicleDeleteLoadingEvent extends VehicleEvent {
  const VehicleDeleteLoadingEvent();
}

class VehicleDeleteErrorEvent extends VehicleEvent {
  final String error;

  const VehicleDeleteErrorEvent({required this.error});

  @override
  List<Object?> get props => [error];
}

class VehicleDeleteSuccessEvent extends VehicleEvent {
  const VehicleDeleteSuccessEvent();
}
