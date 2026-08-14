import 'package:essentials/essentials.dart';
import 'package:lello/feature/vehicles/domain/entities/vehicle_entity.dart';

abstract class VehiclesEvent extends Equatable {
  const VehiclesEvent();

  @override
  List<Object?> get props => [];
}

class VehiclesLoadingEvent extends VehiclesEvent {
  const VehiclesLoadingEvent();
}

class VehiclesFailureEvent extends VehiclesEvent {
  const VehiclesFailureEvent();
}

class VehiclesSuccessEvent extends VehiclesEvent {
  final List<Vehicle> vehicles;

  const VehiclesSuccessEvent({required this.vehicles});

  @override
  List<Object?> get props => [vehicles];
}

class VehiclesEmptyEvent extends VehiclesEvent {
  const VehiclesEmptyEvent();
}
