import 'package:essentials/analytics/analytics_log_events.dart';
import 'package:essentials/analytics/events/analytics_event.dart';
import 'package:essentials/enum/app_origin_enum.dart';

class OwnerAnalyticsLogEvents {
  static void logEvent({
    required AnalyticsEvent event,
    required String unitValue,
    required String referenceValue,
    required String userId,
    Map<String, String>? otherParameters,
  }) {
    AnalyticsLogEvents.logEvent(
      event: event,
      unitValue: unitValue,
      referenceValue: referenceValue,
      userId: userId,
      otherParameters: otherParameters,
      appOrigin: AppOriginEnum.owner,
    );
  }
}
