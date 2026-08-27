# Testes do pacote app-lello-essentials

Objetivo: cobrir `lib/` com testes unitários, de integração (fluxos reais com
plugins/serviços falsos), de interação (widget) e goldens, até ≥ 90% de
linhas por área. É um PACOTE (sem `ApplicationContainer`, sem app): cada
classe é instanciada direto no teste.

## Regras
- NÃO altere nada em `lib/` (código de produção). Se encontrar um defeito,
  documente no teste com `/// Defeito: ...`, teste o comportamento atual e
  liste no relatório final.
- NÃO edite `test/helpers/*` nem `pubspec.yaml` (outros agentes usam em
  paralelo). Helpers extras: crie na pasta de teste da sua área.
- NÃO rode `flutter pub get` nem a suíte inteira. Rode só seus arquivos:
  `flutter test --timeout 60s test/<area>`.
- Cobertura só da sua área (não sobrescreva `coverage/lcov.info`):
  `flutter test --coverage --coverage-path=coverage/<area>.lcov.info test/<area>`
  `python3 test/coverage_summary.py coverage/<area>.lcov.info lib/<pasta>`
  (o lcov só lista arquivos importados pelos testes: arquivo ausente = 0%).
- Testes em português; arquivos `test/<area>/<arquivo>_test.dart` espelhando
  `lib/`. Goldens em `test/<area>/goldens/` gerados com `--update-goldens`.
- Importe pelo caminho do arquivo (`package:essentials/ui/widget/...`) ou pelo
  barrel `package:essentials/essentials.dart` (cuidado com nomes que colidem
  com `flutter_test`: `hide isNull, isNotNull`, e com `Image` de `package:image`).

## Helpers (`test/helpers/`)
- `pump_app.dart` — `pumpApp(tester, widget, {surface, wrapInScaffold,
  shrinkWrap, dark, locOverrides, settle, navigatorObserver, routes, locale})`
  monta o widget num MaterialApp com `LelloTheme`, `AppLocalization` de teste
  (devolve a própria chave → `find.text('minha_chave')`, ou `locOverrides`)
  e localizações do Material; imagens de rede viram PNG 1x1.
  `findGoldenSurface()` para goldens, `findRoute(nome)` para rotas desconhecidas,
  `RecordingNavigatorObserver` (`pushedNames`/`popped`).
- `test_localization.dart` — `TestLoc`/`TestLocDelegate`.
- `firebase_mocks.dart` — `setUpFakeFirebase({remoteConfigValues, initialMessage})`
  (core, crashlytics, messaging, performance, remote config mutável via
  `.values`, analytics falso `fakeAnalytics` com `eventNames/events`, Datadog
  no-op, canal do Adjust).
- `fake_permission_handler.dart` (`setFakePermissionHandler(FakePermissionHandler(status: ...))`),
  `fake_url_launcher.dart` (`installFakeUrlLauncher()` → `launched`/`headers`/`result`),
  `fake_local_auth.dart` (`installFakeLocalAuth()`).
- `load_golden_fonts.dart` — fontes reais para goldens (chamado pelo `pumpApp`).
- `flutter_test_config.dart` — comparador de goldens tolerante.

## Armadilhas do testWidgets (fake async)
- Nunca aguarde IO real (arquivos, Hive, sqflite, `Future.delayed` real) fora de
  `tester.runAsync(...)`: trava. `PackageInfo.setMockInitialValues`,
  `SharedPreferences.setMockInitialValues` e canais mockados com
  `TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
  .setMockMethodCallHandler(const MethodChannel('nome'), handler)` funcionam.
- "A Timer is still pending": consuma com `tester.pump(Duration(...))` ou
  desmonte (`tester.pumpWidget(const SizedBox())`).
- `pumpAndSettle` estoura com animação infinita (loading): use `settle: false`
  + `tester.pump()`.
- Overflow de layout vira exceção: use `surface` maior ou documente como
  defeito com `tester.takeException()`.
- `http.get`/`Dio()` criados internamente: intercepte com
  `http.runWithClient(body, () => MockClient(...))` (package:http/testing) ou
  `HttpOverrides`; o `TestWidgetsFlutterBinding` responde 400 para HttpClient.
- Plugins sem implementação (camera, geolocator, share, open_file, in_app_review,
  contacts, file_picker, image_picker, flutter_local_notifications…): mocke o
  `MethodChannel` ou a `*Platform.instance` (com `MockPlatformInterfaceMixin`).

## O que cobrir
- Todos os ramos públicos: parâmetros opcionais, estados vazios/erro, callbacks.
- Widgets: render, interação (tap, enterText, validação, diálogos/bottom sheets),
  e pelo menos 1 golden por widget visual relevante (`matchesGoldenFile`).
- Modelos/JSON: `fromJson`/`toJson` round trip, campos nulos.
- Serviços (analytics, app_update, launch, files, geolocation): fluxo completo
  com os fakes acima, assertando os efeitos (eventos logados, URLs abertas,
  arquivos escritos em `Directory.systemTemp`).
