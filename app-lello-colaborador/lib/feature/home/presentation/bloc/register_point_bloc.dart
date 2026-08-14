import 'package:colaborador/feature/home/presentation/bloc/register_point_event.dart';
import 'package:colaborador/feature/home/presentation/bloc/register_point_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'package:colaborador/feature/home/presentation/bloc/register_point_event.dart';
export 'package:colaborador/feature/home/presentation/bloc/register_point_state.dart';

class RegisterPointBloc extends Bloc<RegisterPointEvent, RegisterPointState> {
  RegisterPointBloc() : super(const RegisterPointInitialState()) {
    on<RegisterPointSuccessEvent>(handleRegisterPointSuccessEvent);
    on<StartRegisterPointEvent>(handleStartRegisterPointEvent);
    on<RegisterPointFailureEvent>(handleRegisterPointFailureEvent);
    on<NoLocationPermissionEvent>(handleNoLocationPermissionEvent);
    on<OutOfRangeEvent>(handleOutOfRangeEvent);
    on<OfflineFailureEvent>(handleOfflineFailureEvent);
    on<WorkLeaveEvent>(handleWorkLeaveEvent);
    on<DeviceTypeFailureEvent>(handleDeviceTypeFailureEvent);
  }

  void handleStartRegisterPointEvent(
      StartRegisterPointEvent event, Emitter emit) {
    emit(const StartRegisterPointState());
  }

  void handleRegisterPointSuccessEvent(
      RegisterPointSuccessEvent event, Emitter emit) {
    emit(const RegisterPointFaceCaptureState());
  }

  void handleRegisterPointFailureEvent(
      RegisterPointFailureEvent event, Emitter emit) {
    emit(RegisterPointFailureState(message: event.message));
  }

  void handleNoLocationPermissionEvent(
      NoLocationPermissionEvent event, Emitter emit) {
    emit(const NoLocationPermissionState());
  }

  void handleOutOfRangeEvent(OutOfRangeEvent event, Emitter emit) {
    emit(const OutOfRangeState());
  }

  void handleOfflineFailureEvent(OfflineFailureEvent event, Emitter emit) {
    emit(const OfflineFailureState());
  }

  void handleWorkLeaveEvent(WorkLeaveEvent event, Emitter emit) {
    emit(WorkLeaveState(description: event.description));
  }

  void handleDeviceTypeFailureEvent(
      DeviceTypeFailureEvent event, Emitter emit) {
    emit(
      DeviceTypeFailureState(
        onlyPhone: event.onlyPhone,
        onlyTablet: event.onlyTablet,
      ),
    );
  }
}
