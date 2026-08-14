import 'package:essentials/essentials.dart';

import 'facedetection_bloc_event.dart';
import 'facedetection_bloc_state.dart';

class FaceDetectionBloc extends Bloc<FaceDetectionEvent, FaceDetectionState> {
  FaceDetectionBloc(super.initialState) {
    on<MoveHeadRight>(handleMoveHeadRight);
    on<MoveHeadLeft>(handleMoveHeadLeft);
    on<MoveHeadUp>(handleMoveHeadUp);
    on<MoveHeadDown>(handleMoveHeadDown);
    on<MoveSmile>(handleMoveSmile);
    on<MoveBlink>(handleMoveBlink);
    on<MoveHeadCenterInitial>(handleMoveHeadCenterInitial);
    on<MoveHeadCenterAfter>(handleMoveHeadCenterAfter);
    on<DetectionFailure>(handleDetectionFailure);
    on<FaceDetected>(handleFaceDetected);
    on<TakeManualPhoto>(handleTakeManualPhoto);
  }

  void handleMoveHeadRight(
    MoveHeadRight event,
    Emitter<FaceDetectionState> emit,
  ) {
    emit(FaceMovingRightState());
  }

  void handleMoveHeadLeft(
    MoveHeadLeft event,
    Emitter<FaceDetectionState> emit,
  ) {
    emit(FaceMovingLeftState());
  }

  void handleMoveHeadUp(
    MoveHeadUp event,
    Emitter<FaceDetectionState> emit,
  ) {
    emit(FaceMovingUpState());
  }

  void handleMoveHeadDown(
    MoveHeadDown event,
    Emitter<FaceDetectionState> emit,
  ) {
    emit(FaceMovingDownState());
  }

  void handleMoveSmile(
    MoveSmile event,
    Emitter<FaceDetectionState> emit,
  ) {
    emit(FaceMovingSmileState());
  }

  void handleMoveBlink(
    MoveBlink event,
    Emitter<FaceDetectionState> emit,
  ) {
    emit(FaceMovingBlinkState());
  }

  void handleMoveHeadCenterInitial(
    MoveHeadCenterInitial event,
    Emitter<FaceDetectionState> emit,
  ) {
    emit(FaceInitialCenterState());
  }

  void handleMoveHeadCenterAfter(
    MoveHeadCenterAfter event,
    Emitter<FaceDetectionState> emit,
  ) {
    emit(FaceAfterCenterState(text: event.text));
  }

  void handleFaceDetected(
    FaceDetected event,
    Emitter<FaceDetectionState> emit,
  ) {
    emit(FaceDetectedState(count: event.count));
  }

  void handleDetectionFailure(
    DetectionFailure event,
    Emitter<FaceDetectionState> emit,
  ) {
    emit(FaceFailureState());
  }

  void handleTakeManualPhoto(
    TakeManualPhoto event,
    Emitter<FaceDetectionState> emit,
  ) {
    emit(TakeManualPhotoState());
  }
}
