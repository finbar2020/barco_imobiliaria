import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'load_golden_fonts.dart';
import 'test_localization.dart';

const goldenSurfaceKey = Key('golden-surface');

Finder findGoldenSurface() => find.byKey(goldenSurfaceKey);

ThemeData readableTheme({Color? scaffoldBackgroundColor, bool dark = false}) {
  final base = dark ? LelloTheme.dark : LelloTheme.light;
  var theme = base.copyWith(
    textTheme: base.textTheme.apply(fontFamily: 'Roboto'),
  );
  if (scaffoldBackgroundColor != null) {
    theme = theme.copyWith(scaffoldBackgroundColor: scaffoldBackgroundColor);
  }
  return theme;
}

/// Monta [child] dentro de um MaterialApp com tema Lello, o `AppLocalization`
/// de teste (que devolve a própria chave, ou [locOverrides]) e as
/// localizações do Material. Pronto para goldens (`findGoldenSurface()`) e
/// testes de interação. Imagens de rede viram um PNG 1x1.
///
/// [routes]/[onGenerateRoute] e [navigatorObserver] servem para verificar
/// navegação; rotas desconhecidas viram um `Scaffold` com
/// `Key('route:<nome>')` (veja [findRoute]).
Future<void> pumpApp(
  WidgetTester tester,
  Widget child, {
  Size surface = const Size(400, 800),
  bool wrapInScaffold = true,
  bool shrinkWrap = true,
  bool dark = false,
  Map<String, String> locOverrides = const {},
  Color? scaffoldBackgroundColor,
  bool settle = true,
  NavigatorObserver? navigatorObserver,
  Map<String, WidgetBuilder> routes = const {},
  Locale locale = const Locale('pt', 'BR'),
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

  await mockNetworkImagesFor(() => tester.pumpWidget(
        MaterialApp(
          theme: readableTheme(
            scaffoldBackgroundColor: scaffoldBackgroundColor,
            dark: dark,
          ),
          locale: locale,
          supportedLocales: const [Locale('pt', 'BR'), Locale('en', 'US')],
          localizationsDelegates: [
            TestLocDelegate(overrides: locOverrides),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          navigatorObservers: [if (navigatorObserver != null) navigatorObserver],
          onGenerateRoute: (settings) {
            final builder = routes[settings.name];
            return MaterialPageRoute(
              settings: settings,
              builder: builder ??
                  (_) => Scaffold(
                        key: Key('route:${settings.name}'),
                        body: Text('rota ${settings.name}'),
                      ),
            );
          },
          home: home,
        ),
      ));
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
}

/// Finder da tela de destino gerada por [pumpApp] para rotas desconhecidas.
Finder findRoute(String name) => find.byKey(Key('route:$name'));

/// Observador simples para verificar navegações disparadas pelo widget.
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

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) pushed.add(newRoute);
  }
}
