import 'dart:io';
import 'package:essentials/essentials.dart';
import 'package:flutter/services.dart';

class UrlLauncherNative {
  static const platform = MethodChannel('com.example.app/url_launcher');

  /// Abre uma URL, utilizando a abordagem nativa no iOS e `url_launcher` em outras plataformas.
  static Future<bool> openUrl(
    String url, {
    Map<String, String>? headers,
    bool useNativeFallback = true,
  }) async {
    var ignoreForceNative = false;
    try {
      //TODO: Remover ignoreForceNative e if Platform.isIOS apos publicação de nova versão superior a morar 1.26.x sindico 1.25.x
      var info = await AppInfo.init();
      PackageInfo packageInfo = info.packageInfo;
      int versionCkeck = packageInfo.packageName.contains("morar") ? 26 : 25;
      ignoreForceNative =
          int.parse(packageInfo.version.split(".")[1]) > versionCkeck;
    } catch (e) {
      print(e);
    }

    // Verifica se é iOS
    if (Platform.isIOS && !ignoreForceNative) {
      return await _openUrlNative(url);
    }

    try {
      if (headers != null && headers.isNotEmpty) {
        // Tenta abrir usando `url_launcher` com headers
        final Uri uri = Uri.parse(url);
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
          webViewConfiguration: WebViewConfiguration(headers: headers),
        );
        if (!launched) {
          throw Exception("Can't launch URL with headers");
        }
        return true;
      } else {
        // Tenta abrir usando `url_launcher` em um navegador externo
        final Uri uri = Uri.parse(url);
        final launched =
            await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (!launched) {
          throw Exception("Can't launch URL");
        }
        return true;
      }
    } catch (e) {
      print("Erro ao abrir a URL com `url_launcher`: $e");

      // Usa o fallback nativo se permitido
      if (useNativeFallback) {
        return await _openUrlNative(url);
      }
      return false;
    }
  }

  /// Fallback para abrir URL usando a implementação nativa
  static Future<bool> _openUrlNative(String url) async {
    try {
      await platform.invokeMethod('openUrl', {'url': url});
      return true;
    } on PlatformException catch (e) {
      print("Erro ao abrir a URL nativamente: ${e.message}");
      return false;
    }
  }
}
