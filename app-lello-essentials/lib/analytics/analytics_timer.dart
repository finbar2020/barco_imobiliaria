import 'dart:developer';

import 'package:essentials/analytics/analytics_log_events.dart';
import 'package:essentials/analytics/events/analytics_event.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';

class AnalyticsTimer {
  final String userType;
  final String userId;
  final AnalyticsEvent event;
  final String referenceValue;
  final AppOriginEnum appOrigin;
  final String? unitValue;
  final Map<String, String> otherParameters;

  late DateTime _startTime;
  late DateTime _endTime;

  AnalyticsTimer({
    required this.userType,
    required this.userId,
    required this.event,
    required this.referenceValue,
    required this.appOrigin,
    this.unitValue,
    this.otherParameters = const {},
  }) : _startTime = DateTime.now();

  void stopTimer() {
    _endTime = DateTime.now();
    logEvent();
    resetTimer();
  }

  Duration getDuration() {
    return _endTime.difference(_startTime);
  }

  void logEvent() {
    final duration = getDuration();
    if (duration.inSeconds <= 0) {
      return;
    }

    final defaultParameters = {
      'userType': userType,
      'startDate': _startTime.toFormattedString(),
      'endDate': _endTime.toFormattedString(),
      'startHour': DateFormat("HH:mm:ss").format(_startTime),
      'endHour': DateFormat("HH:mm:ss").format(_endTime),
      'durationInSeconds': duration.inSeconds.toString(),
    };

    Map<String, String> allParameters = {
      ...otherParameters,
      ...defaultParameters
    };

    log(allParameters.toString());
    AnalyticsLogEvents.logEvent(
      event: event,
      referenceValue: referenceValue,
      appOrigin: appOrigin,
      unitValue: unitValue,
      userId: userId,
      otherParameters: allParameters,
    );
  }

  void resetTimer() {
    _startTime = DateTime.now();
    _endTime = DateTime.now();
  }
}
