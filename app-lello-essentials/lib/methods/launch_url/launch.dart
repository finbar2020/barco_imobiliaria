import 'package:another_flushbar/flushbar.dart';
import 'package:essentials/methods/launch_url/urls.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../app_localization.dart';

class Launch {
  static Future<bool> urlString(
    BuildContext context,
    String? url, {
    String? cantLaunchMessage,
    LaunchMode? mode,
    WebViewConfiguration? webViewConfiguration,
    bool showFlushbarOnError = true,
    Map<String, String>? headers,
  }) async {
    if (url != null && await canLaunchUrlString(url)) {
      return launchUrlString(
        url,
        mode: mode ?? LaunchMode.platformDefault,
        webViewConfiguration: webViewConfiguration ??
            WebViewConfiguration(headers: headers ?? {}),
      );
    } else {
      return _onLaunchFailed(
        context,
        message: cantLaunchMessage,
        showFlushbarOnError: showFlushbarOnError,
      );
    }
  }

  static Future<bool> urlUri(
    BuildContext context,
    Uri? url, {
    String? cantLaunchMessage,
    LaunchMode? mode,
    WebViewConfiguration? webViewConfiguration,
    bool showFlushbarOnError = true,
  }) async {
    if (url != null && await canLaunchUrl(url)) {
      return launchUrl(
        url,
        mode: mode ?? LaunchMode.platformDefault,
        webViewConfiguration:
            webViewConfiguration ?? const WebViewConfiguration(),
      );
    } else {
      return _onLaunchFailed(
        context,
        message: cantLaunchMessage,
        showFlushbarOnError: showFlushbarOnError,
      );
    }
  }

  static Future<bool> whatsApp(
    BuildContext context,
    String phone, {
    String? message,
    String? cantLaunchMessage,
    bool showFlushbarOnError = true,
  }) async {
    Uri whatsAppUrl = UrlsUri.whatsApp(phone, message: message);
    if (await canLaunchUrl(whatsAppUrl)) {
      return launchUrl(
        whatsAppUrl,
        mode: LaunchMode.externalApplication,
      );
    } else {
      return _onLaunchFailed(
        context,
        message: cantLaunchMessage ?? getString(context, "cant_open_whatsapp"),
        showFlushbarOnError: showFlushbarOnError,
      );
    }
  }

  static Future<bool> sms(
    BuildContext context,
    String phone,
  ) async {
    Uri url = UrlsUri.sms(phone);
    if (await canLaunchUrl(url)) {
      return launchUrl(url);
    } else {
      return _onLaunchFailed(context);
    }
  }

  static Future<bool> tel(
    BuildContext context,
    String phone,
  ) async {
    Uri url = UrlsUri.tel(phone);
    if (await canLaunchUrl(url)) {
      return launchUrl(url);
    } else {
      return _onLaunchFailed(context);
    }
  }

  static bool _onLaunchFailed(BuildContext context,
      {String? message, bool showFlushbarOnError = true}) {
    if (!showFlushbarOnError) {
      return false;
    }
    Flushbar(
        duration: Duration(seconds: 3),
        message: message ?? getString(context, "unable_to_load"))
      ..show(context);

    return false;
  }
}
