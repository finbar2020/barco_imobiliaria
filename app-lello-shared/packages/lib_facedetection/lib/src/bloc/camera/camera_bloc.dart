import 'package:flutter_bloc/flutter_bloc.dart';

import 'camera_bloc_event.dart';
import 'camera_bloc_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraBloc(super.initialState) {
    on<LoadingCamera>(handleLoadingCamera);
    on<SuccessCamera>(handleSuccessCamera);
    on<ManualCapture>(handleManualCapture);
  }

  void handleLoadingCamera(LoadingCamera event, Emitter<CameraState> emit) {
    emit(LoadingCameraState());
  }

  void handleSuccessCamera(SuccessCamera event, Emitter<CameraState> emit) {
    emit(SuccessCameraState());
  }

  void handleManualCapture(ManualCapture event, Emitter<CameraState> emit) {
    emit(ManualCaptureState());
  }
}
