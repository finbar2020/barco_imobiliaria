import 'dart:async';
import 'package:essentials/essentials.dart';

class GetCustomPositionUseCase
    implements UseCase<Position, ParamsGetCustomPositionUseCase> {
  Position? _lastPosition;
  DateTime? _lastPositionTime;
  Stopwatch? sw;

  int accuracyLevel = 0;

  bool isOnline;

  GetCustomPositionUseCase({required this.isOnline});

  @override
  Future<Try<Position>> call(params) async {
    Position? finalPosition;

    try {
      sw = Stopwatch()..start();
      // Get Position from memory
      finalPosition = _getMemoryPosition(params.debouncerTime);
      if (finalPosition != null) return Success(finalPosition);

      // Get current Position
      finalPosition = await _getCurrentPosition(isOnline, 20);

      // Get Last know Position
      finalPosition ??= await _getLastKnowPosition();

      // Update memory Position
      _lastPosition = finalPosition;
      _lastPositionTime = DateTime.now().toUtc();
      sw?.stop();

      logAnalytics(finalPosition);

      if (finalPosition == null) return Rejection(UnknownFailure(""));

      return Success(finalPosition);
    } catch (e) {
      return Rejection(UnknownFailure(""));
    }
  }

  Position? _getMemoryPosition(int debounceTime) {
    if (_lastPositionTime != null) {
      final DateTime dateNow = DateTime.now();

      final bool isValid = _lastPositionTime!
          .isAfter(dateNow.subtract(Duration(seconds: debounceTime)));

      if (isValid) {
        return _lastPosition;
      }
    }
    return null;
  }

  Future<Position?> _getCurrentPosition(bool internetIsOn, int timeout) async {
    Position? position;
    final DateTime startTime = DateTime.now();
    try {
      if (internetIsOn) {
        final Map<LocationAccuracy, Duration> sequenceParams = {
          LocationAccuracy.high: const Duration(seconds: 2),
          LocationAccuracy.medium: const Duration(seconds: 5),
          LocationAccuracy.lowest: const Duration(seconds: 2)
        };

        for (var cnt = 0; cnt < sequenceParams.length; cnt++) {
          try {
            if (DateTime.now().difference(startTime).inSeconds < timeout) {
              final LocationAccuracy currentAccuracy =
                  sequenceParams.keys.toList()[cnt];

              position = await Geolocator.getCurrentPosition(
                desiredAccuracy: currentAccuracy,
                forceAndroidLocationManager:
                    _getAccuracyCode(currentAccuracy) != 0,
                timeLimit: sequenceParams[currentAccuracy],
              );

              accuracyLevel = _getAccuracyCode(currentAccuracy);

              return position;
            } else
              break;
          } catch (_) {}
        }
      } else {
        // Internet off
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.lowest,
          forceAndroidLocationManager: false,
          timeLimit: const Duration(seconds: 4),
        );
        accuracyLevel = 3;

        return position;
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  Future<Position?> _getLastKnowPosition() async {
    Position? position;
    try {
      position = await Geolocator.getLastKnownPosition()
          .timeout(const Duration(milliseconds: 1500));

      accuracyLevel = 9;

      if (position != null &&
          DateTime.now().difference(position.timestamp).inMinutes < 3) {
        return position;
      }
    } catch (_) {}
    return null;
  }

  int _getAccuracyCode(LocationAccuracy accuracy) {
    switch (accuracy) {
      case LocationAccuracy.bestForNavigation:
        return 5;
      case LocationAccuracy.best:
        return 4;
      case LocationAccuracy.high:
        return 3;
      case LocationAccuracy.medium:
        return 2;
      case LocationAccuracy.low:
        return 1;
      case LocationAccuracy.lowest:
        return 0;
      default:
        return 6;
    }
  }

  logAnalytics(Position? pos) {
    if (pos == null) {
      FirebaseAnalytics.instance.logEvent(name: "get_location_err");
    } else {
      FirebaseAnalytics.instance
          .logEvent(name: "get_location_succ", parameters: {
        "accuracy": pos.accuracy.toString(),
        "accuracy_requested": accuracyLevel.toString(),
        "elapsed_ms": sw?.elapsedMilliseconds.toString() ?? "",
        "cache": pos == _lastPosition ? "true" : "false",
      });
    }
  }
}

class ParamsGetCustomPositionUseCase {
  final int debouncerTime;
  const ParamsGetCustomPositionUseCase({this.debouncerTime = 30});
}
