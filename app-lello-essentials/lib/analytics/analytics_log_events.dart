import 'dart:developer';

import 'package:essentials/analytics/adjust/analytics_adjust_config.dart';
import 'package:essentials/analytics/events/analytics_event.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsLogEvents {
  static Future<void> logEvent({
    required AnalyticsEvent event,
    required String referenceValue,
    required AppOriginEnum appOrigin,
    String? unitValue,
    String? userId,
    String? userType,
    Map<String, String>? otherParameters,
  }) async {
    Map<String, String> parameters = {
      "tipo": event.type,
    };
    if (referenceValue.isNotEmpty) {
      parameters.addAll({
        "referencia": referenceValue,
      });
    }
    if ((unitValue ?? "").isNotEmpty) {
      parameters.addAll({
        "unidade": unitValue!,
      });
    }
    if ((userId ?? "").isNotEmpty) {
      parameters.addAll({
        "userId": userId!,
      });
    }
    if ((userType ?? "").isNotEmpty) {
      parameters.addAll({
        "userType": userType!,
      });
    }
    if (otherParameters != null) {
      parameters.addAll(otherParameters);
    }

    try {
      log("Logando evento ${event.name} com parâmetros: $parameters");
      await FirebaseAnalytics.instance
          .logEvent(name: event.name, parameters: parameters)
          .then((_) {
        print('Evento ${event.name} logado com sucesso.');
      });

      AnalyticsAdjustConfig.logAdjustEvent(
          event: event, appOrigin: appOrigin, parameters: parameters);
    } catch (error) {
      print('Erro ao logar evento ${event.name}: $error');
    }
  }
}
