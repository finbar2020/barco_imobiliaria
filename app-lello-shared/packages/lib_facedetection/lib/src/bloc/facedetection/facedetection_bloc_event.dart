abstract class FaceDetectionEvent {}

class FaceDetectionMoviment extends FaceDetectionEvent {}

class MoveHeadRight extends FaceDetectionEvent {}

class MoveHeadLeft extends FaceDetectionEvent {}

class MoveHeadUp extends FaceDetectionEvent {}

class MoveHeadDown extends FaceDetectionEvent {}

class MoveSmile extends FaceDetectionEvent {}

class MoveBlink extends FaceDetectionEvent {}

class MoveHeadCenterInitial extends FaceDetectionEvent {}

class DetectionFailure extends FaceDetectionEvent {}

class TakeManualPhoto extends FaceDetectionEvent {}

class FaceDetected extends FaceDetectionEvent {
  final int count;
  FaceDetected({
    required this.count,
  });
}

class MoveHeadCenterAfter extends FaceDetectionEvent {
  String text;
  MoveHeadCenterAfter({
    required this.text,
  });
}
