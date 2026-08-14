import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/unit/presentation/bloc/vehicles/vehicles_event.dart';
import 'package:lello/feature/unit/presentation/bloc/vehicles/vehicles_state.dart';

class VehiclesBloc extends Bloc<VehiclesEvent, VehiclesState> {
  VehiclesBloc() : super(const VehiclesEmptyState()) {
    on<VehiclesLoadingEvent>(handleVehiclesLoadingEvent);
    on<VehiclesFailureEvent>(handleVehiclesFailureEvent);
    on<VehiclesSuccessEvent>(handleVehiclesSuccessEvent);
    on<VehiclesEmptyEvent>(handleVehiclesEmptyEvent);
  }

  void handleVehiclesLoadingEvent(VehiclesLoadingEvent event, Emitter emit) {
    emit(const VehiclesLoadingState());
  }

  void handleVehiclesFailureEvent(VehiclesFailureEvent event, Emitter emit) {
    emit(const VehiclesFailureState());
  }

  void handleVehiclesSuccessEvent(VehiclesSuccessEvent event, Emitter emit) {
    emit(VehiclesSuccessState(vehicles: event.vehicles));
  }

  void handleVehiclesEmptyEvent(VehiclesEmptyEvent event, Emitter emit) {
    emit(const VehiclesEmptyState());
  }
}
