# Testes do pacote app-lello-shared (`package:shared_features`)

Objetivo: cobrir `lib/` com testes unitários, de integração (fluxos reais com
HTTP/plugins/Firebase falsos), de interação (widget) e goldens, até ≥ 90% de
linhas por feature. É um PACOTE compartilhado pelos apps; não há
`ApplicationContainer` real — as páginas recebem `appContainer:` (um
`SharedApplicationContainer`) e resolvem dependências com
`appContainer.resolve<T>()`.

## Regras
- NÃO altere nada em `lib/` (código de produção). Defeito encontrado:
  documente no teste com `/// Defeito: ...`, teste o comportamento atual e
  liste no relatório final.
- NÃO edite `test/helpers/*` nem `pubspec.yaml` (outros agentes usam em
  paralelo). Helpers extras: crie na pasta de teste da sua feature.
- NÃO rode `flutter pub get` nem a suíte inteira. Rode só seus arquivos:
  `flutter test --timeout 60s test/feature/<x>`.
- Cobertura só da sua feature (não sobrescreva `coverage/lcov.info`):
  `flutter test --coverage --coverage-path=coverage/<x>.lcov.info test/feature/<x>`
  `python3 test/coverage_summary.py coverage/<x>.lcov.info lib/feature/<x>`
  (o lcov só lista arquivos importados pelos testes: arquivo ausente = 0%).
- Testes em português; arquivos `test/feature/<x>/<arquivo>_test.dart`
  espelhando `lib/`. Goldens em `test/feature/<x>/goldens/` com `--update-goldens`.

## Imports
A maior parte do pacote é `part of shared_features`: importe
`package:shared_features/shared_features.dart` (com `hide isNull, isNotNull`
para não colidir com o flutter_test; `hide Image` se usar `Image` do Flutter
junto com `essentials`). Arquivos que NÃO são `part` (core/widgets, core/modal,
core/circuit_breaker, core/database, core/network, launcher_url,
start_security, alguns `*_api.dart`/`*_model.dart`) são importados pelo
caminho, ex. `package:shared_features/core/widgets/custom_app_bar.dart`.
Classes privadas (`_Xxx`) dos parts não são acessíveis: teste pelo público.

## Helpers (`test/helpers/`)
- `test_container.dart` — `TestSharedContainer` (`register<T>(obj)`,
  `registerLazy<T>(() => ...)`, `registerFactory<T>(...)`, `resolve<T>()`,
  `getBaseUrl()`, `reset()`): passe como `appContainer:` para as páginas e
  registre o que elas resolvem (`Environment`, stores, blocs, use cases,
  `NotificationController`, etc.). Prefira registrar as classes REAIS do
  pacote ligadas a data sources/APIs com HTTP falso; use fakes
  (`class _FakeX extends Fake implements X`) só para o que for inviável.
- `fake_http.dart` — `FakeHttp` (`on('GET', '/caminho', body: {...},
  status:)`, `failAll()`, `requests`) + `buildChopperClient(fakeHttp)` para
  criar as `*Api.create(client)` reais. Caminho = path da URL sem query; `*`
  no fim casa prefixo. Veja os `@Get/@Post(path:)` das APIs e os `*.g.dart`
  dos modelos para montar o JSON (listas precisam ser listas, datas ISO).
- `pump_app.dart` — `pumpApp(tester, widget, {...})` para widgets soltos
  (golden em `findGoldenSurface()`), `pumpPage(tester, page, {arguments,
  routes, observer, surface, settle, locOverrides, providers})` para páginas
  inteiras (rota nomeada, `ModalRoute` args, rotas desconhecidas viram
  `Scaffold` com `Key('route:<nome>')` → `findRoute(nome)`;
  `RecordingNavigatorObserver` com `pushedNames`/`popped`; `providers` para
  envolver com `BlocProvider.value`). Textos: o `AppLocalization` de teste
  devolve a própria chave → `find.text('minha_chave')`; `locOverrides` para
  textos reais quando o layout depender do tamanho.
- `firebase_mocks.dart` — `setUpFakeFirebase({remoteConfigValues,
  initialMessage})` (core, crashlytics, messaging com `getToken`, performance,
  remote config mutável `.values`, analytics falso `fakeAnalytics`, Datadog
  no-op, canal do Adjust). Firestore: `FakeFirebaseFirestore()` do
  fake_cloud_firestore (ex.: `CircuitBreakerController(database: ...)`).
- `fake_permission_handler.dart`, `fake_url_launcher.dart`
  (`installFakeUrlLauncher()`), `fake_local_auth.dart`, `test_localization.dart`,
  `load_golden_fonts.dart`, `flutter_test_config.dart` (comparador tolerante).
- Sessão: muitas classes recebem `dynamic sessionBloc`/`session`; crie um fake
  local com os membros usados (`state.session?.condominium?.reference`,
  `checkRback`, `getRemoteConfig`...). Hive (`AccessTokenLocalDataSourceImpl`,
  banners/documents): `Hive.init(Directory.systemTemp.createTempSync().path)`
  em `setUp` e opere dentro de `tester.runAsync` (IO real).

## Armadilhas do testWidgets (fake async)
- Nunca aguarde IO real (Hive, arquivos, `Future.delayed` real) fora de
  `tester.runAsync(...)`: trava. `SharedPreferences.setMockInitialValues`,
  `PackageInfo.setMockInitialValues` e canais mockados funcionam.
- Crie blocs/stores DENTRO do `testWidgets` (ou em `setUp` só se não tiverem
  handlers assíncronos que a tela espere): handlers criados fora da zona fake
  não completam para o `BlocBuilder`. `emit` direto no bloc é permitido
  (`// ignore: invalid_use_of_visible_for_testing_member`) e precisa de um
  `pump()` extra.
- "A Timer is still pending": consuma com `tester.pump(Duration(...))` ou
  desmonte (`tester.pumpWidget(const SizedBox())`). `ConnectionController`
  liga um `Timer.periodic` de 30s no construtor — chame `onDispose()` ou
  crie-o em `setUp`.
- `pumpAndSettle` estoura com animação infinita: `settle: false` + `pump()`.
- Overflow de layout vira exceção: `surface` maior, `locOverrides` com textos
  curtos, ou documente como defeito com `tester.takeException()`.
- `http.get`/`Dio()` internos: `http.runWithClient(body, () => MockClient(...))`
  ou `HttpOverrides`. Plugins (camera, face detection, share, open_file,
  in_app_review, contacts, file_picker, image_picker, local notifications,
  webview): mocke o `MethodChannel` ou `*Platform.instance`
  (`MockPlatformInterfaceMixin`). `UrlLauncherNative` tem fallback nativo no
  canal `com.example.app/url_launcher` (responda com `PlatformException` para
  devolver `false`).
- `lib/samples/` é código de exemplo: não precisa de testes.

## O que cobrir
- Domínio/dados: entidades, `fromJson`/`toJson`/`toEntity` (nulos), repositórios
  (sucesso/falha via `FakeHttp`), use cases.
- Blocs/stores/controllers: todos os eventos e estados, sequências de emissão.
- Páginas/widgets: todos os estados, interações (tap, enterText, validação,
  diálogos/bottom sheets, scroll), navegação (rota + argumentos), voltar,
  retry; pelo menos 1 golden por página principal.
