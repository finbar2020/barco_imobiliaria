import 'package:morar/feature/tdb/domain/entity/tdb_param.dart';

class TDBInfo {
  String redirectLink;
  List<TDBParam?> information;

  TDBInfo({
    required this.redirectLink,
    required this.information,
  });

  Uri? get urlAndQueries {
    if (redirectLink.isEmpty) {
      return null;
    }
    Map<String, String> queryParameters = {};
    information.forEach((element) {
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

    List<String> urlParts = redirectLink.split("://");
    scheme = urlParts.length == 1 ? "https" : urlParts.first;
    String urlBody = urlParts.last;

    Uri.parse(redirectLink);

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
    information.forEach((element) {
      if (element?.type == "HEADER" &&
          element?.nameParam != null &&
          element?.param != null) {
        header.addAll({element!.nameParam: element.param});
      }
    });
    return header;
  }

  Uri get redirectLinkURL => Uri.parse(redirectLink);
}
