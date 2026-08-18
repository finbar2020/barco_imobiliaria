import 'package:essentials/ui/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'load_golden_fonts.dart';
import 'test_localization.dart';

const goldenSurfaceKey = Key('golden-surface');

Finder findGoldenSurface() => find.byKey(goldenSurfaceKey);

ThemeData _readableTheme({Color? scaffoldBackgroundColor}) {
  final base = LelloTheme.light;
  var theme = base.copyWith(
    textTheme: base.textTheme.apply(fontFamily: 'Roboto'),
  );
  if (scaffoldBackgroundColor != null) {
    theme = theme.copyWith(scaffoldBackgroundColor: scaffoldBackgroundColor);
  }
  return theme;
}

Future<void> pumpApp(
  WidgetTester tester,
  Widget child, {
  Size surface = const Size(400, 800),
  bool localized = false,
  bool wrapInScaffold = true,
  bool shrinkWrap = true,
  Map<String, String> locOverrides = const {},
  Color? scaffoldBackgroundColor,
  bool settle = true,
}) async {
  await tester.runAsync(loadGoldenFonts);
  tester.view.physicalSize = surface;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final padded = Padding(
    padding: const EdgeInsets.all(16),
    child: SizedBox(
      width: surface.width - 32,
      height: shrinkWrap ? null : surface.height - 32,
      child: shrinkWrap ? IntrinsicHeight(child: child) : child,
    ),
  );

  final home = wrapInScaffold
      ? Scaffold(
          backgroundColor: Colors.white,
          body: Align(
            alignment: Alignment.topCenter,
            child: RepaintBoundary(
              key: goldenSurfaceKey,
              child: ColoredBox(
                color: Colors.white,
                child: padded,
              ),
            ),
          ),
        )
      : RepaintBoundary(
          key: goldenSurfaceKey,
          child: ColoredBox(
            color: scaffoldBackgroundColor ?? Colors.white,
            child: child,
          ),
        );
  final theme = _readableTheme(scaffoldBackgroundColor: scaffoldBackgroundColor);

  await tester.pumpWidget(
    localized
        ? MaterialApp(
            theme: theme,
            locale: const Locale('pt', 'BR'),
            supportedLocales: const [Locale('pt', 'BR')],
            localizationsDelegates: [
              TestLocDelegate(overrides: locOverrides),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: home,
          )
        : MaterialApp(
            theme: theme,
            home: home,
          ),
  );
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
}
