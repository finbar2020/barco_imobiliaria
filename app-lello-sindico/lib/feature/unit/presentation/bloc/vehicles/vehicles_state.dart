import 'package:essentials/essentials.dart';
import 'package:lello/feature/vehicles/domain/entities/vehicle_entity.dart';

abstract class VehiclesState extends Equatable {
  const VehiclesState();

  @override
  List<Object?> get props => [];
}

class VehiclesLoadingState extends VehiclesState {
  const VehiclesLoadingState();
}

class VehiclesFailureState extends VehiclesState {
  const VehiclesFailureState();
}

class VehiclesSuccessState extends VehiclesState {
  final List<Vehicle> vehicles;

  const VehiclesSuccessState({required this.vehicles});

  @override
  List<Object?> get props => [vehicles];
}

class VehiclesEmptyState extends VehiclesState {
  const VehiclesEmptyState();
}
