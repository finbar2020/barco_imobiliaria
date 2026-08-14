import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morar/feature/vehicles/presentation/bloc/vehicle_event.dart';
import 'package:morar/feature/vehicles/presentation/bloc/vehicle_state.dart';

class VehiclesBloc extends Bloc {
  VehiclesBloc() : super(const VehicleIsEmptyState()) {
    on<VehicleIsEmptyEvent>(handleVehicleIsEmptyEvent);
    on<VehicleLoadedDataEvent>(handleVehicleLoadedDataEvent);
    on<LoadingInProgressEvent>(handleVehicleAddInProgressEvent);
    on<VehicleAddingFailedEvent>(handleVehicleAddFailedEvent);
    on<VehicleAddSuccessEvent>(handleVehicleAddSuccessEvent);
    on<LoadingInProgressDataEvent>(handleVehicleInProgressDataEvent);
    on<VehicleLoadingFailedEvent>(handleVehicleLoadingFailedEvent);
    on<VehicleLoadingUpdateInProgressEvent>(handleVehicleLoadingProgressEvent);
    on<UpdateVehicleEvent>(handleVehicleUpdateEvent);
    on<VehicleDeleteLoadingEvent>(handleVehicleDeleteLoadingEvent);
    on<VehicleDeleteErrorEvent>(handleVehicleDeleteErrorEvent);
    on<VehicleDeleteSuccessEvent>(handleVehicleDeleteSuccessEvent);
  }
  void handleVehicleIsEmptyEvent(VehicleIsEmptyEvent event, Emitter emit) {
    emit(const VehicleIsEmptyState());
  }

  void handleVehicleAddInProgressEvent(
      LoadingInProgressEvent event, Emitter emit) {
    emit(const VehicleLoadingAddInProgressState());
  }

  void handleVehicleAddFailedEvent(
      VehicleAddingFailedEvent event, Emitter emit) {
    emit(VehicleAddingFailedState(event.error, event.message));
  }

  void handleVehicleAddSuccessEvent(
      VehicleAddSuccessEvent event, Emitter emit) {
    emit(VehicleAddedState(event.vehicles));
  }

  void handleVehicleInProgressDataEvent(
      LoadingInProgressDataEvent event, Emitter emit) {
    emit(const VehicleLoadingDataInProgressState());
  }

  void handleVehicleLoadingFailedEvent(
      VehicleLoadingFailedEvent event, Emitter emit) {
    emit(VehicleLoadingFailedState(event.error));
  }

  void handleVehicleLoadedDataEvent(
      VehicleLoadedDataEvent event, Emitter emit) {
    emit(VehicleIsLoadedDataState(
        vehicle: event.vehicles, session: event.session));
  }

  void handleVehicleLoadingProgressEvent(
      VehicleLoadingUpdateInProgressEvent event, Emitter emit) {
    emit(const VehicleLoadingUpdateInProgressState());
  }

  void handleVehicleUpdateEvent(UpdateVehicleEvent event, Emitter emit) {
    emit(const VehicleUpdatedState());
  }

  void handleVehicleDeleteLoadingEvent(
      VehicleDeleteLoadingEvent event, Emitter emit) {
    emit(const VehicleLoadingDeleteInProgressState());
  }

  void handleVehicleDeleteErrorEvent(
      VehicleDeleteErrorEvent event, Emitter emit) {
    emit(DeleteVehicleErrorState(event.error));
  }

  void handleVehicleDeleteSuccessEvent(
      VehicleDeleteSuccessEvent event, Emitter emit) {
    emit(const VehicleRemovedState());
  }
}
