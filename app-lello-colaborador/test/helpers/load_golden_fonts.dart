import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

bool _loaded = false;

Future<void> loadGoldenFonts() async {
  if (_loaded) return;
  TestWidgetsFlutterBinding.ensureInitialized();

  await _loadFamily('Roboto', [
    'fonts/Roboto-Regular.ttf',
    'fonts/Roboto-Bold.ttf',
    'fonts/Roboto-Black.ttf',
  ]);
  await _loadFamily('Anek Latin', [
    'fonts/Roboto-Regular.ttf',
    'fonts/Roboto-Bold.ttf',
    'fonts/Roboto-Black.ttf',
  ]);

  final icons = _materialIconsPath();
  if (icons != null) {
    await _loadFamily('MaterialIcons', [icons]);
  }

  _loaded = true;
}

Future<void> _loadFamily(String family, List<String> paths) async {
  final loader = FontLoader(family);
  var added = false;
  for (final path in paths) {
    final file = File(path);
    if (!file.existsSync()) continue;
    final bytes = await file.readAsBytes();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
    added = true;
  }
  if (added) {
    await loader.load();
  }
}

String? _materialIconsPath() {
  final roots = <String>[
    if (Platform.environment['FLUTTER_ROOT'] case final root?) root,
    r'C:\tools\flutter',
  ];
  for (final root in roots) {
    final path =
        '$root${Platform.pathSeparator}bin${Platform.pathSeparator}cache${Platform.pathSeparator}artifacts${Platform.pathSeparator}material_fonts${Platform.pathSeparator}materialicons-regular.otf';
    if (File(path).existsSync()) return path;
  }
  return null;
}
