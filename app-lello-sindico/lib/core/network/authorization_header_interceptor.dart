import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:essentials/configs/client_flavor_header_resolver.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:shared_features/shared_features.dart';

class AuthorizationHeaderInterceptor implements Interceptor {
  final AccessTokenLocalDataSource dataSource;
  final ApiPerformaceMonitor monitor;
  AuthorizationHeaderInterceptor({
    required this.dataSource,
    required this.monitor,
  });
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
      Chain<BodyType> chain) async {
    String? jwt;
    String packageName = "";
    String version = "";
    Map<String, String> customHeadres = <String, String>{};

    try {
      final token = await dataSource.select(role: "");
      jwt = token?.accessToken;
      //TODO: Mover para app initialize para não precisar ficar chamando a todo request
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      version = packageInfo.version;
      packageName = packageInfo.packageName;
    } catch (err) {
      jwt = null;
      version = "unidentified";
      packageName = "";
    }

    //set version name in request header
    customHeadres["app-version"] = version;

    //set Lello-Client-Type in request header
    customHeadres["X-Lello-Client-Type"] = "APPSINDICO";

    //set Lello-Flavor in request header
    customHeadres["X-Lello-Flavor"] = ClientFlavorHeaderResolver.resolve(
      appOrigin: AppOriginEnum.manager,
      packageName: packageName,
    );

    //set company id in request header
    customHeadres["idEmpresa"] = ClientFlavorHeaderResolver.resolveCompanyId();

    if (jwt != null) {
      customHeadres["Authorization"] = "Bearer $jwt";

      try {
        final parts = jwt.split('.');
        if (parts.length == 3) {
          final payload = parts[1];
          // Add padding if needed for base64 decoding
          final normalizedPayload = base64.normalize(payload);
          final decodedBytes = base64.decode(normalizedPayload);
          final decodedPayload = utf8.decode(decodedBytes);
          final payloadMap =
              json.decode(decodedPayload) as Map<String, dynamic>;

          final uit = payloadMap['uit'] as String?;
          if (uit != null && uit.isNotEmpty) {
            debugPrint('🔑 UIT Token: $uit');
          }
        }
      } catch (e) {
        debugPrint('❌ Error extracting UIT from JWT: $e');
      }
    }
    customHeadres = await monitor.start(chain.request, customHeadres);
    Request request = chain.request;
    if (customHeadres.isNotEmpty) {
      request = applyHeaders(chain.request, customHeadres);
    }
    final response = await chain.proceed(request);

    await monitor.stop(response);
    return response;
  }
}
