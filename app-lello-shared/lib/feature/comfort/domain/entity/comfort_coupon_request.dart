import 'package:shared_features/feature/comfort/domain/entity/comfort_coupon_request_param.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_cta_enum.dart';

class ComfortCouponRequest {
  String idRequest;
  List<ComfortCouponRequestParam?> params;
  String linkRedirectPartner;
  bool redirectExternal = false;
  ComfortCTA cta = ComfortCTA.cupom;

  ComfortCouponRequest({
    required this.idRequest,
    required this.params,
    required this.linkRedirectPartner,
    required this.redirectExternal,
    required this.cta,
  });

  Uri? get urlAndQueries {
    if (linkRedirectPartner.isEmpty) {
      return null;
    }
    Map<String, String> queryParameters = {};
    params.forEach((element) {
      if (element?.type == "QUERY" &&
          element?.nameParam != null &&
          element?.param != null) {
        queryParameters.addAll({element!.nameParam: element.param});
      }
    });

    Uri uri;
    String? scheme;
    String? host;
    String? path;

    List<String> urlParts = linkRedirectPartner.split("://");
    scheme = urlParts.length == 1 ? "https" : urlParts.first;
    String urlBody = urlParts.last;

    if (urlBody.contains("/")) {
      host = urlBody.split("/").first;
      path = urlBody.split(host).last;
    } else {
      host = urlBody;
    }
    uri = Uri(
      scheme: scheme,
      host: host,
      path: path,
      queryParameters: queryParameters,
    );
    return uri;
  }

  Map<String, String> get headers {
    Map<String, String> header = {};
    params.forEach((element) {
      if (element?.type == "HEADER" &&
          element?.nameParam != null &&
          element?.param != null) {
        header.addAll({element!.nameParam: element.param});
      }
    });
    return header;
  }

  String? get callBack {
    String? callBack;
    params.forEach((element) {
      if (element?.nameParam == "url-callback" && element?.param != null) {
        callBack = element?.param;
      }
    });
    return callBack;
  }
}
