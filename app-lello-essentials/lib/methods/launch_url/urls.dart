class UrlsUri {
  static Uri lgpd() =>
      Uri.https("www.lellocondominios.com.br", "lgpd-e-lello-condominios");
  static Uri privacyPolicy() => Uri.https(
      "www.lello.com.br", "politica-de-privacidade/lello-condominios");
  static Uri vamosParcelar() =>
      Uri.https("credenciado.vamosparcelar.com.br", "lello-condominios");
  static Uri resolvaFacilPreferenciasEditar() => Uri.https(
      "www.lellocondominios.com.br", "resolvafacil/preferencias/editar.xhtml");
  static Uri pontoDigital({required String url}) =>
      Uri.https(url != "" ? url : "www.applelloparacolaboradores.com.br", "/");
  static Uri indiqueGanhe({required String url, required String path}) =>
      Uri.https(url != "" ? url : "www.indicalello.com.br",
          path != "" ? path : "souzelador");
  static Uri condoLivre({required String url, required String path}) =>
      Uri.https(url != "" ? url : "cred.condolivre.com.br",
          path != "" ? path : "home");
  static Uri cursos({required String url, required String path}) => Uri.https(
      url != "" ? url : "www.cursos.sindiconet.com.br",
      path != "" ? path : "zeladoria-na-pratica-e-manutencao-predial");

  static Uri whatsApp(String phone, {String? message}) {
    String path = "$phone/";
    Map<String, dynamic>? queryParameters = {"text": message};
    return Uri.https("wa.me", path, queryParameters);
  }

  static Uri tel(String? phone) => Uri(scheme: "tel", host: phone);
  static Uri sms(String? phone) => Uri(scheme: "sms", host: phone);
}

class UrlsString {}
