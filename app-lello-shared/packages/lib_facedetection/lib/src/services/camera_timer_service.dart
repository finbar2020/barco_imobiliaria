class CameraTimerService {
  final int minSecondsToTakePhoto;

  DateTime? firstOk;
  DateTime? lastOk;
  late Stopwatch stopwatchManualCapture;
  late Stopwatch stopwatchDisableLifeValidation;
  late Stopwatch stopwatchTotalCapture;
  int ticksFaceCheck = 0;
  bool _lifeValidationComplete = false;

  CameraTimerService({
    required this.minSecondsToTakePhoto,
  });

  void startTimers() {
    stopwatchManualCapture = Stopwatch()..start();
    stopwatchTotalCapture = Stopwatch()..start();
    stopwatchDisableLifeValidation = Stopwatch();
    ticksFaceCheck = 0;
    _lifeValidationComplete = false;
    firstOk = null;
  }

  void incrementFaceCheck() {
    ticksFaceCheck++;
  }

  DateTime incrementTakePhoto() {
    if (_lifeValidationComplete) {
      firstOk ??= DateTime.now();
    }
    lastOk = DateTime.now();
    return lastOk!;
  }

  void restartTakePhotoCounter() {
    firstOk = null;
  }

  void startLifeValidationTimer() {
    if (!stopwatchDisableLifeValidation.isRunning) {
      stopwatchDisableLifeValidation.start();
      stopwatchDisableLifeValidation.reset();
    }
  }

  void stopLifeValidationTimer() {
    stopwatchDisableLifeValidation.stop();
  }

  void handleFaceDetected({
    required bool isDetected,
    required void Function() onNoFaceDetected,
  }) {
    if (isDetected) {
      stopwatchManualCapture.stop();
    } else {
      if (!stopwatchManualCapture.isRunning) {
        stopwatchManualCapture.start();
        stopwatchManualCapture.reset();
      }
      stopLifeValidationTimer();
      _lifeValidationComplete = false;
      firstOk = null;
      onNoFaceDetected();
    }
  }

  void setLifeValidationComplete() {
    _lifeValidationComplete = true;
  }

  bool get disableLifeValidation =>
      stopwatchDisableLifeValidation.isRunning &&
      stopwatchDisableLifeValidation.elapsedMilliseconds > 30000;

  bool get isTimeoutReached =>
      stopwatchManualCapture.elapsedMilliseconds > 5000;

  int get countDownTakePhoto => _lifeValidationComplete
      ? (minSecondsToTakePhoto - _takedPhoto).toInt()
      : minSecondsToTakePhoto;

  bool get hasStartedCounting => firstOk != null;

  bool get isSuficientTimeToCapture =>
      _lifeValidationComplete && _takedPhoto >= minSecondsToTakePhoto;

  double get _takedPhoto => firstOk == null
      ? 0
      : DateTime.now().difference(firstOk!).inMilliseconds / 1000;

  int get performanceMetric =>
      ticksFaceCheck <= 0 || stopwatchTotalCapture.elapsed.inSeconds <= 0
          ? 0
          : ticksFaceCheck ~/ (stopwatchTotalCapture.elapsed.inSeconds);

  Stopwatch get totalCapture => stopwatchTotalCapture;
}
