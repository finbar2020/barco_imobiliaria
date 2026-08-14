import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:essentials/configs/client_flavor_header_resolver.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_features/shared_features.dart';

class AuthorizationHeaderInterceptor implements Interceptor {
  final AccessTokenLocalDataSource dataSource;
  AuthorizationHeaderInterceptor({required this.dataSource});
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
    customHeadres["X-Lello-Client-Type"] = "APPDPREP";

    //set Lello-Flavor in request header
    customHeadres["X-Lello-Flavor"] = ClientFlavorHeaderResolver.resolve(
      appOrigin: AppOriginEnum.employee,
      packageName: packageName,
    );

    //set company id in request header
    customHeadres["idEmpresa"] = ClientFlavorHeaderResolver.resolveCompanyId();

    if (jwt != null) {
      customHeadres["Authorization"] = "Bearer $jwt";
    }

    Request request = chain.request;
    if (customHeadres.isNotEmpty) {
      request = applyHeaders(chain.request, customHeadres);
    }
    final response = await chain.proceed(request);

    return response;
  }
}
