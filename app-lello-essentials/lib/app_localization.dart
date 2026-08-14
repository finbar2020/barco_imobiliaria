import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalization {
  final Locale locale;
  late Map<String, String> _localizedStrings;

  AppLocalization(this.locale);

  static const LocalizationsDelegate<AppLocalization> delegate =
      _AppLocalizationDelegate();

  static AppLocalization of(BuildContext context) {
    return Localizations.of(context, AppLocalization);
  }

  Future load() async {
    String packageLanguage =
        "lang/${locale.languageCode}_${locale.countryCode}.json";
    if (locale.languageCode == 'en' && locale.countryCode == 'BR') {
      packageLanguage = "lang/en_US.json";
    }
    String fileContent = await rootBundle.loadString(packageLanguage);
    Map<String, dynamic> map = json.decode(fileContent);
    _localizedStrings = map.map((k, v) {
      return MapEntry(k.toString(), v.toString());
    });
  }

  String? translate(String key) {
    return _localizedStrings[key];
  }
}

String getString(BuildContext? context, String key, {String defaultText = ""}) {
  if (kIsWeb) {
    return defaultText;
  } else {
    return context != null
        ? (AppLocalization.of(context).translate(key) ?? defaultText)
        : defaultText;
  }
}

String getStringWithParams(
    BuildContext? context, String key, List<String> params) {
  String? text = getString(context, key);
  for (int i = 0; i < params.length; i++) {
    text = text!.replaceAll("{$i}", params[i]);
  }
  return text!;
}

class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const _AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return ["pt", "en"].contains(locale.languageCode);
  }

  @override
  Future<AppLocalization> load(Locale locale) async {
    var localizations = AppLocalization(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalization> old) => false;
}
