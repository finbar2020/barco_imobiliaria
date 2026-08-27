import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class TestLoc extends AppLocalization {
  TestLoc({this.overrides = const {}}) : super(const Locale('pt', 'BR'));

  final Map<String, String> overrides;

  @override
  String? translate(String key) => overrides[key] ?? key;
}

class TestLocDelegate extends LocalizationsDelegate<AppLocalization> {
  const TestLocDelegate({this.overrides = const {}});

  final Map<String, String> overrides;

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalization> load(Locale locale) async =>
      TestLoc(overrides: overrides);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalization> old) =>
      false;
}
