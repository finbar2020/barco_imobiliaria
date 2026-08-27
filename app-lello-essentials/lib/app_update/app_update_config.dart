import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:essentials/app_update/update_check_response.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_localization.dart';
import '../configs/custom_firebase_remote_config.dart';
import '../enum/app_origin_enum.dart';
import 'needs_update_enum.dart';

class AppUpdateConfig {
  static Future<UpdateCheckResponse?> checkNeedsUpdate(
      {required AppOriginEnum appOriginEnum}) async {
    String _key = "UPDATE_DATE_CHECK";
    try {
      FirebaseRemoteConfig? remoteConfig = await _initFirebaseRemoteConfig();

      if (remoteConfig == null) return null;

      String storeVersion = await _getStoreVersionRemoteConfig(remoteConfig);

      if (storeVersion.isEmpty) return null;

      final prefs = await SharedPreferences.getInstance();

      var date = prefs.get(_key);

      if (date is! String) {
        prefs.remove(_key);
        date = null;
      }

      if (date == null || date == '') {
        await prefs.setString(_key,
            DateTime.now().subtract(const Duration(days: 3)).toIso8601String());
        date = prefs.getString(_key);
      }
      final dateCheck = _checkDateDifference(date);

      String minVersionRequiredValue =
          await _checkMinVersionRequired(remoteConfig);
      String localVersion = await getLocalVersion();

      bool needUpdate = _compareVersion(localVersion, storeVersion);

      if (!needUpdate) return null;

      if (minVersionRequiredValue.isEmpty) return null;

      final criticalUpdateRequired =
          _compareVersion(storeVersion, minVersionRequiredValue);
      if (criticalUpdateRequired)
        return UpdateCheckResponse(needsUpdate: NeedsUpdate.mandatory);
      else if (dateCheck == true) {
        return UpdateCheckResponse(needsUpdate: NeedsUpdate.minor);
      } else {
        return UpdateCheckResponse(needsUpdate: NeedsUpdate.none);
      }
    } catch (e, a) {
      FirebaseCrashlytics.instance.recordError(e, a);
      SharedPreferences.getInstance().then((prefs) => prefs.remove(_key));
      return null;
    }
  }

  static showDialogUpDate(
      {required BuildContext context,
      required AppOriginEnum appOriginEnum,
      required bool criticalUpdateRequired,
      required Function continueSplashAction,
      Function? dismissAction}) async {
    try {
      _setDate();
      String id = _getAppId(appOriginEnum);
      String? storeLink = await getAppStoreLink(id);
      return showAlertUpdateDialog(
        context: context,
        appStoreLink: storeLink ?? "",
        continueSplashAction: continueSplashAction,
        allowDismissal: criticalUpdateRequired ? false : true,
        dialogTitle: getString(context, 'new_version_app_title'),
        dialogText: getString(
            context,
            criticalUpdateRequired
                ? 'new_version_app_critical_dialog_text'
                : 'new_version_app_dialog_text'),
        dismissAction: () {
          Navigator.pop(context);
          _registerAnalycsEvents(appOriginEnum: appOriginEnum);
          dismissAction?.call();
        },
        dismissButtonText: getString(context, 'no_update_app'),
        updateButtonText: getString(context, 'yes_update_app'),
      );
    } catch (e, a) {
      FirebaseCrashlytics.instance.recordError(e, a);
    }
  }

  static Future<FirebaseRemoteConfig?> _initFirebaseRemoteConfig() async {
    try {
      final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: Duration(seconds: 30),
          minimumFetchInterval: Duration(minutes: 30)));
      await remoteConfig.fetch();
      await remoteConfig.activate();
      return remoteConfig;
    } catch (e) {
      return null;
    }
  }

  static Future<String> _getStoreVersionRemoteConfig(
      FirebaseRemoteConfig remoteConfig) async {
    String storeVersionValue;
    try {
      var storeVersion = jsonDecode(
          remoteConfig.getString(CustomFirebaseRemoteConfig.storeVersion));
      storeVersionValue = storeVersion["storeVersion"];
      return storeVersionValue.isNotEmpty ? storeVersionValue : "";
    } catch (e) {
      return "";
    }
  }

  static Future<String> _checkMinVersionRequired(
      FirebaseRemoteConfig remoteConfig) async {
    String forceUpdateValue;
    try {
      var forceUpdate = jsonDecode(
          remoteConfig.getString(CustomFirebaseRemoteConfig.forceUpdate));
      forceUpdateValue = forceUpdate["minVersion"];
      return forceUpdateValue.isNotEmpty ? forceUpdateValue : "";
    } catch (e) {
      return "";
    }
  }

  static bool _compareVersion(String localVersion, String remoteVersion) {
    if (localVersion == remoteVersion || localVersion.isEmpty) {
      return false;
    }

    var versionLocal = localVersion.split(".");
    var versionRemote = remoteVersion.split(".");

    // Segmentos ausentes contam como 0 (1.2 == 1.2.0 < 1.2.1). Segmentos não
    // numéricos continuam lançando (tratado no catch de quem chama).
    final length = versionLocal.length > versionRemote.length
        ? versionLocal.length
        : versionRemote.length;
    for (int i = 0; i < length; i++) {
      int v1int = i < versionLocal.length ? int.parse(versionLocal[i]) : 0,
          v2int = i < versionRemote.length ? int.parse(versionRemote[i]) : 0;
      if (v1int > v2int) {
        return false;
      } else if (v1int < v2int) {
        return true;
      }
    }
    return false;
  }

  static bool? _checkDateDifference(date) {
    try {
      var dateNow = DateTime.now();
      var otherDate = DateTime.parse(date as String);
      final int difference = dateNow.difference(otherDate).inDays;
      return difference > 0 ? true : false;
    } catch (e) {
      return true;
    }
  }

  static Future<void> _setDate() async {
    String _key = "UPDATE_DATE_CHECK";
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, DateTime.now().toString());
  }

  static void _registerAnalycsEvents({required appOriginEnum}) {
    FirebaseAnalytics.instance.logEvent(
      name: appOriginEnum == AppOriginEnum.manager
          ? "sindico_atualizacao_adiada_read"
          : "morar_atualizacao_adiada_read",
      parameters: {
        "tipo": "read",
      },
    );
  }

  static Future<String?> getAppStoreLink(String appId) async {
    if (Platform.isAndroid) {
      if (appId.isEmpty) {
        return null;
      } else {
        return "https://play.google.com/store/apps/details?id=$appId&hl=br";
      }
    } else {
      String iOSAppStoreCountry = 'br';
      final parameters = {"bundleId": "$appId"};
      parameters.addAll({"country": iOSAppStoreCountry});
      var uri = Uri.https("itunes.apple.com", "/lookup", parameters);
      final response = await http.get(uri);
      final jsonObj = json.decode(response.body);
      final List results = jsonObj['results'];
      if (results.isEmpty) {
        debugPrint('Can\'t find an app in the App Store with the id: $appId');
        return null;
      } else {
        return jsonObj['results'][0]['trackViewUrl'];
      }
    }
  }

  static showAlertUpdateDialog({
    required BuildContext context,
    required String appStoreLink,
    required Function continueSplashAction,
    String dialogTitle = 'Update Available',
    String? dialogText,
    String updateButtonText = 'Update',
    bool allowDismissal = false,
    String dismissButtonText = 'Maybe Later',
    VoidCallback? dismissAction,
  }) async {
    final dialogTitleWidget = Text(dialogTitle);
    final dialogTextWidget = Text(
      dialogText ?? 'You can now update this app',
    );

    final updateButtonTextWidget = Text(updateButtonText);
    final updateAction = () {
      if (appStoreLink.isEmpty) {
        Navigator.of(context, rootNavigator: true).pop();
        continueSplashAction();
      } else {
        // `launchAppStore` já chama `continueSplashAction` (uma única vez).
        launchAppStore(appStoreLink, context, continueSplashAction);
        if (allowDismissal) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      }
    };

    List<Widget> actions = [
      Platform.isAndroid
          ? TextButton(
              child: updateButtonTextWidget,
              onPressed: updateAction,
            )
          : CupertinoDialogAction(
              child: updateButtonTextWidget,
              onPressed: updateAction,
            ),
    ];

    if (allowDismissal) {
      final dismissButtonTextWidget = Text(dismissButtonText);
      dismissAction = dismissAction ??
          () {
            Navigator.of(context, rootNavigator: true).pop();
            continueSplashAction();
          };
      actions.add(
        Platform.isAndroid
            ? TextButton(
                child: dismissButtonTextWidget,
                onPressed: dismissAction,
              )
            : CupertinoDialogAction(
                child: dismissButtonTextWidget,
                onPressed: dismissAction,
              ),
      );
    }

    await showDialog(
      context: context,
      barrierDismissible: allowDismissal,
      builder: (BuildContext context) {
        return WillPopScope(
            child: Platform.isAndroid
                ? AlertDialog(
                    title: dialogTitleWidget,
                    content: dialogTextWidget,
                    actions: actions,
                  )
                : CupertinoAlertDialog(
                    title: dialogTitleWidget,
                    content: dialogTextWidget,
                    actions: actions,
                  ),
            onWillPop: () {
              // Só segue a splash quando o diálogo realmente fecha.
              if (allowDismissal) continueSplashAction();
              return Future.value(allowDismissal);
            });
      },
    );
  }

  static Future<void> launchAppStore(
    String appStoreLink,
    BuildContext context,
    Function continueSplashAction,
  ) async {
    debugPrint(appStoreLink);
    if (await canLaunch(appStoreLink)) {
      await launch(appStoreLink);
      continueSplashAction();
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      continueSplashAction();
    }
  }

  static String _getAppId(AppOriginEnum appOriginEnum) {
    if (appOriginEnum == AppOriginEnum.owner) {
      if (Platform.isAndroid) {
        return 'app.lello.morar';
      } else {
        return 'app.lello.lellomorar';
      }
    } else if (appOriginEnum == AppOriginEnum.manager) {
      if (Platform.isAndroid) {
        return 'app.lello.sindico';
      } else {
        return 'app.lello.sindico';
      }
    } else {
      return "";
    }
  }

  static Future<String> getLocalVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
