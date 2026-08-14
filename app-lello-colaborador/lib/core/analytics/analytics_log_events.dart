import 'dart:developer';

import 'package:essentials/analytics/analytics_log_events.dart';
import 'package:essentials/analytics/events/analytics_event.dart';
import 'package:essentials/enum/app_origin_enum.dart';

class EmployeeAnalyticsLogEvents {
  static void logEvent({
    required AnalyticsEvent event,
    required String referenceValue,
    Map<String, String>? otherParameters,
  }) {
    log("firing event: ${event.name}, type: ${event.type}, reference: $referenceValue, parameters: ${otherParameters.toString()}",
        name: "AnalyticsLogEvent");
    AnalyticsLogEvents.logEvent(
      event: event,
      referenceValue: referenceValue,
      otherParameters: otherParameters,
      appOrigin: AppOriginEnum.employee,
    );
  }
}
