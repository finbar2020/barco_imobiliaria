import 'dart:developer';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:adjust_sdk/adjust_event_failure.dart';
import 'package:adjust_sdk/adjust_event_success.dart';
import 'package:adjust_sdk/adjust_session_failure.dart';
import 'package:adjust_sdk/adjust_session_success.dart';
import 'package:essentials/analytics/events/analytics_event.dart';
import 'package:essentials/enum/app_origin_enum.dart';

class AnalyticsAdjustConfig {
  // Platform messages are asynchronous, so we initialize in an async method.
  static initPlatformState({
    required AppOriginEnum appOriginEnum,
    required AdjustEnvironment adjustEnvironment,
  }) async {
    String token = "";

    if (appOriginEnum == AppOriginEnum.manager) {
      token = "m80e1uxzam80";
    } else if (appOriginEnum == AppOriginEnum.owner) {
      token = "bupp99brj6rk";
    } else if (appOriginEnum == AppOriginEnum.employee) {
      token = "kx9jjsx9ghkw";
    }
    AdjustConfig config = new AdjustConfig(token, adjustEnvironment);
    config.logLevel = AdjustLogLevel.verbose;

    config.attributionCallback = (AdjustAttribution attributionChangedData) {
      log('[Adjust]: Attribution changed!');

      if (attributionChangedData.trackerToken != null) {
        log('[Adjust]: Tracker token: ' + attributionChangedData.trackerToken!);
      }
      if (attributionChangedData.trackerName != null) {
        log('[Adjust]: Tracker name: ' + attributionChangedData.trackerName!);
      }
      if (attributionChangedData.campaign != null) {
        log('[Adjust]: Campaign: ' + attributionChangedData.campaign!);
      }
      if (attributionChangedData.network != null) {
        log('[Adjust]: Network: ' + attributionChangedData.network!);
      }
      if (attributionChangedData.creative != null) {
        log('[Adjust]: Creative: ' + attributionChangedData.creative!);
      }
      if (attributionChangedData.adgroup != null) {
        log('[Adjust]: Adgroup: ' + attributionChangedData.adgroup!);
      }
      if (attributionChangedData.clickLabel != null) {
        log('[Adjust]: Click label: ' + attributionChangedData.clickLabel!);
      }
      if (attributionChangedData.costType != null) {
        log('[Adjust]: Cost type: ' + attributionChangedData.costType!);
      }
      if (attributionChangedData.costAmount != null) {
        log('[Adjust]: Cost amount: ' +
            attributionChangedData.costAmount!.toString());
      }
      if (attributionChangedData.costCurrency != null) {
        log('[Adjust]: Cost currency: ' + attributionChangedData.costCurrency!);
      }
    };

    config.sessionSuccessCallback = (AdjustSessionSuccess sessionSuccessData) {
      log('[Adjust]: Session tracking success!');

      if (sessionSuccessData.message != null) {
        log('[Adjust]: Message: ' + sessionSuccessData.message!);
      }
      if (sessionSuccessData.timestamp != null) {
        log('[Adjust]: Timestamp: ' + sessionSuccessData.timestamp!);
      }
      if (sessionSuccessData.adid != null) {
        log('[Adjust]: Adid: ' + sessionSuccessData.adid!);
      }
      if (sessionSuccessData.jsonResponse != null) {
        log('[Adjust]: JSON response: ' + sessionSuccessData.jsonResponse!);
      }
    };

    config.sessionFailureCallback = (AdjustSessionFailure sessionFailureData) {
      log('[Adjust]: Session tracking failure!');

      if (sessionFailureData.message != null) {
        log('[Adjust]: Message: ' + sessionFailureData.message!);
      }
      if (sessionFailureData.timestamp != null) {
        log('[Adjust]: Timestamp: ' + sessionFailureData.timestamp!);
      }
      if (sessionFailureData.adid != null) {
        log('[Adjust]: Adid: ' + sessionFailureData.adid!);
      }
      if (sessionFailureData.willRetry != null) {
        log('[Adjust]: Will retry: ' + sessionFailureData.willRetry.toString());
      }
      if (sessionFailureData.jsonResponse != null) {
        log('[Adjust]: JSON response: ' + sessionFailureData.jsonResponse!);
      }
    };

    config.eventSuccessCallback = (AdjustEventSuccess eventSuccessData) {
      log('[Adjust]: Event tracking success!');

      if (eventSuccessData.eventToken != null) {
        log('[Adjust]: Event token: ' + eventSuccessData.eventToken!);
      }
      if (eventSuccessData.message != null) {
        log('[Adjust]: Message: ' + eventSuccessData.message!);
      }
      if (eventSuccessData.timestamp != null) {
        log('[Adjust]: Timestamp: ' + eventSuccessData.timestamp!);
      }
      if (eventSuccessData.adid != null) {
        log('[Adjust]: Adid: ' + eventSuccessData.adid!);
      }
      if (eventSuccessData.callbackId != null) {
        log('[Adjust]: Callback ID: ' + eventSuccessData.callbackId!);
      }
      if (eventSuccessData.jsonResponse != null) {
        log('[Adjust]: JSON response: ' + eventSuccessData.jsonResponse!);
      }
    };

    config.eventFailureCallback = (AdjustEventFailure eventFailureData) {
      log('[Adjust]: Event tracking failure!');

      if (eventFailureData.eventToken != null) {
        log('[Adjust]: Event token: ' + eventFailureData.eventToken!);
      }
      if (eventFailureData.message != null) {
        log('[Adjust]: Message: ' + eventFailureData.message!);
      }
      if (eventFailureData.timestamp != null) {
        log('[Adjust]: Timestamp: ' + eventFailureData.timestamp!);
      }
      if (eventFailureData.adid != null) {
        log('[Adjust]: Adid: ' + eventFailureData.adid!);
      }
      if (eventFailureData.callbackId != null) {
        log('[Adjust]: Callback ID: ' + eventFailureData.callbackId!);
      }
      if (eventFailureData.willRetry != null) {
        log('[Adjust]: Will retry: ' + eventFailureData.willRetry.toString());
      }
      if (eventFailureData.jsonResponse != null) {
        log('[Adjust]: JSON response: ' + eventFailureData.jsonResponse!);
      }
    };

    config.deferredDeeplinkCallback = (String? uri) {
      log('[Adjust]: Received deferred deeplink: ' + uri!);
    };

    // // Add session callback parameters.
    // Adjust.addSessionCallbackParameter('scp_foo_1', 'scp_bar');
    // Adjust.addSessionCallbackParameter('scp_foo_2', 'scp_value');

    // // Add session Partner parameters.
    // Adjust.addSessionPartnerParameter('spp_foo_1', 'spp_bar');
    // Adjust.addSessionPartnerParameter('spp_foo_2', 'spp_value');

    // // Remove session callback parameters.
    // Adjust.removeSessionCallbackParameter('scp_foo_1');
    // Adjust.removeSessionPartnerParameter('spp_foo_1');

    // // Clear all session callback parameters.
    // Adjust.resetSessionCallbackParameters();

    // // Clear all session partner parameters.
    // Adjust.resetSessionPartnerParameters();

    // // Ask for tracking consent.
    // Adjust.requestTrackingAuthorizationWithCompletionHandler().then((status) {
    //   log('[Adjust]: Authorization status update!');
    //   switch (status) {
    //     case 0:
    //       log(
    //           '[Adjust]: Authorization status update: ATTrackingManagerAuthorizationStatusNotDetermined');
    //       break;
    //     case 1:
    //       log(
    //           '[Adjust]: Authorization status update: ATTrackingManagerAuthorizationStatusRestricted');
    //       break;
    //     case 2:
    //       log(
    //           '[Adjust]: Authorization status update: ATTrackingManagerAuthorizationStatusDenied');
    //       break;
    //     case 3:
    //       log(
    //           '[Adjust]: Authorization status update: ATTrackingManagerAuthorizationStatusAuthorized');
    //       break;
    //   }
    // });

    // Start SDK.
    Adjust.initSdk(config);
  }

  static void logAdjustEvent({
    required AnalyticsEvent event,
    required AppOriginEnum appOrigin,
    required Map<String, String> parameters,
  }) {
    String eventToken = event.token;
    if (eventToken.isNotEmpty) {
      AdjustEvent adjustEvent = new AdjustEvent(eventToken);
      parameters.forEach((key, value) {
        adjustEvent.addCallbackParameter(key, value);
      });
      Adjust.trackEvent(adjustEvent);
    }
  }
}
