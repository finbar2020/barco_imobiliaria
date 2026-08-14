import 'package:essentials/essentials.dart';
import 'package:morar/feature/session/domain/entity/session.dart';
import 'package:morar/feature/vehicles/domain/entity/vehicles.dart';

abstract class VehicleState extends Equatable {
  const VehicleState();

  @override
  List<Object?> get props => [];
}

class VehicleLoadingDataInProgressState extends VehicleState {
  const VehicleLoadingDataInProgressState();
}

class VehicleLoadingAddInProgressState
    extends VehicleLoadingDataInProgressState {
  const VehicleLoadingAddInProgressState();
}

class VehicleLoadingDeleteInProgressState
    extends VehicleLoadingDataInProgressState {
  const VehicleLoadingDeleteInProgressState();
}

class VehicleLoadingUpdateInProgressState
    extends VehicleLoadingDataInProgressState {
  const VehicleLoadingUpdateInProgressState();
}

class VehicleAddedState extends VehicleState {
  final List<Vehicle> vehicle;

  const VehicleAddedState(this.vehicle);

  @override
  List<Object?> get props => [vehicle];
}

class VehicleRemovedState extends VehicleState {
  const VehicleRemovedState();
}

class VehicleUpdatedState extends VehicleState {
  const VehicleUpdatedState();
}

class VehicleIsEmptyState extends VehicleState {
  const VehicleIsEmptyState();
}

class VehicleIsLoadedDataState extends VehicleState {
  final Session session;
  final List<Vehicle> vehicle;

  const VehicleIsLoadedDataState(
      {required this.vehicle, required this.session});

  @override
  List<Object?> get props => [session, vehicle];
}

class VehicleLoadingFailedState extends VehicleState {
  final String failed;

  const VehicleLoadingFailedState(this.failed);

  @override
  List<Object?> get props => [failed];
}

class VehicleAddingFailedState extends VehicleState {
  final String failed;
  final String? message;

  const VehicleAddingFailedState(this.failed, this.message);

  @override
  List<Object?> get props => [failed, message];
}

class DeleteVehicleErrorState extends VehicleState {
  final String msg;

  const DeleteVehicleErrorState(this.msg);

  @override
  List<Object?> get props => [msg];
}
