import 'package:essentials/analytics/analytics_log_events.dart';
import 'package:essentials/analytics/events/analytics_event.dart';
import 'package:essentials/enum/app_origin_enum.dart';

class ManagerAnalyticsLogEvents {
  static void logEvent({
    required AnalyticsEvent event,
    String? userId,
    String? userType,
    required String referenceValue,
    Map<String, String>? otherParameters,
  }) {
    AnalyticsLogEvents.logEvent(
      event: event,
      userId: userId ?? "",
      userType: userType ?? "",
      referenceValue: referenceValue,
      otherParameters: otherParameters,
      appOrigin: AppOriginEnum.manager,
    );
  }
}
