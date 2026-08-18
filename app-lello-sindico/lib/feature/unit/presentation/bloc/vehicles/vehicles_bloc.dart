// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/vehicles/domain/entities/vehicle_entity.dart';

class VehiclesBloc extends Bloc<VehiclesEvent, VehiclesState> {
  VehiclesBloc() : super(VehiclesEmptyState()) {
    on<VehiclesLoadingEvent>(handleVehiclesLoadingEvent);
    on<VehiclesFailureEvent>(handleVehiclesFailureEvent);
    on<VehiclesSuccessEvent>(handleVehiclesSuccessEvent);
    on<VehiclesEmptyEvent>(handleVehiclesEmptyEvent);
  }

  void handleVehiclesLoadingEvent(VehiclesLoadingEvent event, Emitter emit) {
    emit(VehiclesLoadingState());
  }

  void handleVehiclesFailureEvent(VehiclesFailureEvent event, Emitter emit) {
    emit(VehiclesFailureState());
  }

  void handleVehiclesSuccessEvent(VehiclesSuccessEvent event, Emitter emit) {
    emit(VehiclesSuccessState(vehicles: event.vehicles));
  }

  void handleVehiclesEmptyEvent(VehiclesEmptyEvent event, Emitter emit) {
    emit(VehiclesEmptyState());
  }
}

abstract class VehiclesState {}

class VehiclesLoadingState extends VehiclesState {}

class VehiclesFailureState extends VehiclesState {}

class VehiclesSuccessState extends VehiclesState {
  List<Vehicle> vehicles;
  VehiclesSuccessState({
    required this.vehicles,
  });
}

class VehiclesEmptyState extends VehiclesState {}

abstract class VehiclesEvent {}

class VehiclesLoadingEvent extends VehiclesEvent {}

class VehiclesFailureEvent extends VehiclesEvent {}

class VehiclesSuccessEvent extends VehiclesEvent {
  List<Vehicle> vehicles;
  VehiclesSuccessEvent({
    required this.vehicles,
  });
}

class VehiclesEmptyEvent extends VehiclesEvent {}
