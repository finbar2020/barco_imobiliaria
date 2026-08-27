import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'load_golden_fonts.dart';
import 'test_localization.dart';

const goldenSurfaceKey = Key('golden-surface');

/// Rota usada por [pumpPage] para a página sob teste.
const pageRouteName = '/page-under-test';

Finder findGoldenSurface() => find.byKey(goldenSurfaceKey);

/// Finder da tela de destino gerada para rotas desconhecidas.
Finder findRoute(String name) => find.byKey(Key('route:$name'));

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

List<LocalizationsDelegate> _delegates(Map<String, String> locOverrides) => [
      TestLocDelegate(overrides: locOverrides),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ];

Future<void> _setSurface(WidgetTester tester, Size surface) async {
  await tester.runAsync(loadGoldenFonts);
  tester.view.physicalSize = surface;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

/// Monta [child] (um widget solto) dentro de um MaterialApp com tema Lello,
/// `AppLocalization` de teste (devolve a própria chave, ou [locOverrides]) e
/// localizações do Material. Pronto para goldens (`findGoldenSurface()`).
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
}) async {
  await _setSurface(tester, surface);

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
              child: ColoredBox(color: Colors.white, child: padded),
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

  await mockNetworkImagesFor(() => tester.pumpWidget(MaterialApp(
        theme: readableTheme(
            scaffoldBackgroundColor: scaffoldBackgroundColor, dark: dark),
        locale: const Locale('pt', 'BR'),
        supportedLocales: const [Locale('pt', 'BR'), Locale('en', 'US')],
        localizationsDelegates: _delegates(locOverrides),
        navigatorObservers: [if (navigatorObserver != null) navigatorObserver],
        onGenerateRoute: (settings) => MaterialPageRoute(
          settings: settings,
          builder: routes[settings.name] ??
              (_) => Scaffold(
                    key: Key('route:${settings.name}'),
                    body: Text('rota ${settings.name}'),
                  ),
        ),
        home: home,
      )));
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
}

/// Monta [page] (uma página inteira) como rota nomeada [pageRouteName] de um
/// MaterialApp com tema, localização e, opcionalmente, [providers] acima do
/// app (ex.: `BlocProvider.value`). [arguments] chega em
/// `ModalRoute.of(context)!.settings.arguments`. Rotas desconhecidas viram um
/// `Scaffold` com `Key('route:<nome>')` (`findRoute`), e [observer] registra
/// as navegações.
Future<void> pumpPage(
  WidgetTester tester,
  Widget page, {
  Object? arguments,
  Map<String, WidgetBuilder> routes = const {},
  NavigatorObserver? observer,
  Size surface = const Size(400, 800),
  bool settle = true,
  bool dark = false,
  Map<String, String> locOverrides = const {},
  Widget Function(Widget app)? providers,
}) async {
  await _setSurface(tester, surface);

  final app = MaterialApp(
    theme: readableTheme(dark: dark),
    locale: const Locale('pt', 'BR'),
    supportedLocales: const [Locale('pt', 'BR'), Locale('en', 'US')],
    localizationsDelegates: _delegates(locOverrides),
    navigatorObservers: [if (observer != null) observer],
    initialRoute: pageRouteName,
    onGenerateRoute: (settings) {
      if (settings.name == pageRouteName) {
        return MaterialPageRoute(
          settings: RouteSettings(name: pageRouteName, arguments: arguments),
          builder: (_) => page,
        );
      }
      return MaterialPageRoute(
        settings: settings,
        builder: routes[settings.name] ??
            (_) => Scaffold(
                  key: Key('route:${settings.name}'),
                  body: Text('rota ${settings.name}'),
                ),
      );
    },
  );

  await mockNetworkImagesFor(
      () => tester.pumpWidget(providers == null ? app : providers(app)));
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

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) pushed.add(newRoute);
  }
}
