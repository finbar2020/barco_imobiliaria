import 'package:essentials/ui/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/generated/l10n.dart';

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

/// Monta [child] dentro de um MaterialApp pronto para goldens e testes de
/// interação. Com [localized] o app recebe o `AppLocalization` de teste
/// (que devolve a própria chave) e o `S` gerado pelo flutter_intl.
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
  NavigatorObserver? navigatorObserver,
  Map<String, WidgetBuilder> routes = const {},
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
  final observers = [if (navigatorObserver != null) navigatorObserver];

  await tester.pumpWidget(
    localized
        ? MaterialApp(
            theme: theme,
            locale: const Locale('pt', 'BR'),
            supportedLocales: const [Locale('pt', 'BR')],
            localizationsDelegates: [
              TestLocDelegate(overrides: locOverrides),
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            navigatorObservers: observers,
            routes: routes,
            home: home,
          )
        : MaterialApp(
            theme: theme,
            navigatorObservers: observers,
            routes: routes,
            home: home,
          ),
  );
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
}

/// Observador simples para verificar navegações disparadas pela tela.
class RecordingNavigatorObserver extends NavigatorObserver {
  final pushed = <Route<dynamic>>[];
  final popped = <Route<dynamic>>[];

  List<String?> get pushedNames => pushed.map((r) => r.settings.name).toList();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushed.add(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    popped.add(route);
  }

  /// `pushReplacementNamed`/`popAndPushNamed` chegam aqui: a nova rota
  /// também entra em [pushed] para aparecer em [pushedNames].
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) pushed.add(newRoute);
  }
}
