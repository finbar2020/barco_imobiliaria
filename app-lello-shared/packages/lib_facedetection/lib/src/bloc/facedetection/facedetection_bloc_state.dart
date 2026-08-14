abstract class FaceDetectionState {}

class TakeManualPhotoState extends FaceDetectionState {
  @override
  String toString() {
    return 'TakeManualPhotoState';
  }
}

class FaceEmptyState extends FaceDetectionState {
  @override
  String toString() {
    return 'FaceEmptyState';
  }
}

class FaceFailureState extends FaceDetectionState {
  @override
  String toString() {
    return 'FaceFailureState';
  }
}

class FaceMovingState extends FaceDetectionState {
  @override
  String toString() {
    return 'FaceMovingState';
  }
}

class FaceInitialCenterState extends FaceDetectionState {
  @override
  String toString() {
    return 'FaceInitialCenterState';
  }
}

class FaceAfterCenterState extends FaceDetectionState {
  final String text;
  FaceAfterCenterState({
    required this.text,
  });
  @override
  String toString() {
    return 'FaceAfterCenterState text: $text';
  }
}

class FaceMovingRightState extends FaceDetectionState {
  @override
  String toString() {
    return 'FaceMovingRightState';
  }
}

class FaceMovingLeftState extends FaceDetectionState {
  @override
  String toString() {
    return 'FaceMovingLeftState';
  }
}

class FaceMovingUpState extends FaceDetectionState {
  @override
  String toString() {
    return 'FaceMovingUpState';
  }
}

class FaceMovingDownState extends FaceDetectionState {
  @override
  String toString() {
    return 'FaceMovingDownState';
  }
}

class FaceMovingBlinkState extends FaceDetectionState {
  @override
  String toString() {
    return 'FaceMovingBlinkState';
  }
}

class FaceMovingSmileState extends FaceDetectionState {
  @override
  String toString() {
    return 'FaceMovingSmileState';
  }
}

class FaceLoadingState extends FaceDetectionState {
  @override
  String toString() {
    return 'FaceLoadingState';
  }
}

class FaceCenteredState extends FaceDetectionState {
  @override
  String toString() {
    return 'FaceCenteredState';
  }
}

class FaceDetectedState extends FaceDetectionState {
  final int count;
  FaceDetectedState({
    required this.count,
  });

  @override
  bool operator ==(Object other) {
    return other is FaceDetectedState && other.count == count;
  }

  @override
  int get hashCode => count.hashCode;

  @override
  String toString() {
    return 'FaceDetectedState count: $count';
  }
}
