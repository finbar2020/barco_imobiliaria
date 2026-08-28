# Testes de páginas/widgets do app-lello-morar

Objetivo: cobrir as telas (`lib/feature/<x>/presentation/**`) com widget tests
usando o container de DI real + infraestrutura falsa. Referência pronta e
passando: `test/feature/billets/billets_page_test.dart`.

## Regras
- NÃO altere nada em `lib/` (código de produção). Se encontrar um defeito,
  documente no teste (comentário `/// Defeito: ...`) e escreva o teste para o
  comportamento atual; liste os defeitos no seu relatório final.
- NÃO edite os helpers compartilhados em `test/helpers/` nem `pubspec.yaml`
  (outros agentes usam em paralelo). Se precisar de algo extra, crie
  helpers locais em `test/feature/<x>/`.
- NÃO rode `flutter pub get`, nem a suíte inteira. Rode só seus arquivos:
  `flutter test --timeout 60s test/feature/<x>`.
- Cobertura só da sua feature (não sobrescreva `coverage/lcov.info`):
  `flutter test --coverage --coverage-path=coverage/<x>.lcov.info test/feature/<x>`
  `python3 test/coverage_summary.py coverage/<x>.lcov.info lib/feature/<x>`
- Meta: ≥ 90% das linhas de `lib/feature/<x>/` (todos os arquivos somados).
  Itere: rode a cobertura, veja os arquivos com mais linhas faltando, cubra.
- Nomeie os arquivos `test/feature/<x>/<pagina>_test.dart` (um por página ou
  por grupo de widgets). Descrições em português.

## Harness (`test/helpers/page_harness.dart`)
```dart
late PageHarness harness;
setUp(() async { harness = await installPageHarness(); });
```
`installPageHarness()` SEMPRE no `setUp` (nunca dentro do corpo do
`testWidgets`: lá os timers do container viram FakeTimers pendentes). Ele
sobe o `ApplicationContainer` real com Firebase, Datadog,
permission_handler e sms_autofill falsos, `SessionBloc` trocado por
`FakeSessionBloc` (sessão de `testSession()`: condomínio `R1`, unidade `101`,
usuário `testMe()`), `CircuitBreakerController` sobre Firestore em memória e o
`ChopperClient` apontando para `harness.http` (`FakeHttp`).
- `harness.http.on('GET', '/caminho', body: {...}, status: 200)` — cadastre as
  respostas ANTES de `pumpPage`. Caminho = path da URL sem query; `*` no fim
  casa prefixo. `harness.http.failAll()` faz tudo responder 500.
  `harness.http.requests` lista as requisições feitas. Veja o `@Get(path:)` da
  API da feature (`lib/feature/<x>/data/data_source/*_api.dart`) e os modelos
  `*.g.dart` para montar o JSON certo (listas precisam ser listas, datas ISO).
- `harness.sessionBloc` é o `FakeSessionBloc` (mude `session`, `rbacAllowed`,
  `allowedRbacs`, `currentState`, etc. antes de pumpar).
- `harness.remoteConfig.values = {'chave': 'valor'}` muda o remote config
  falso (valores lidos com `getString`; alguns são JSON, ex. `'"1.2.3"'`).
- `harness.resolve<T>()` pega qualquer coisa do container (controller, bloc…).
  Controllers são lazy singletons: o mesmo objeto que a página usa.
- `harness.override<T>(fake)` substitui um registro por um fake (use quando o
  fluxo real for inviável, ex.: use case que acessa câmera/arquivo).
- `pumpPage(tester, const MinhaPage(), arguments: MinhaPageArgs(...), observer:
  RecordingNavigatorObserver(), routes: {...}, settle: true)` monta a página
  como rota nomeada com tema, localização e `SessionBloc` no contexto.
  `arguments` chega em `ModalRoute.of(context)!.settings.arguments`.
  Rotas desconhecidas viram um `Scaffold` com `Key('route:<nome>')` →
  `expect(findRoute(ApplicationRoute.x), findsOneWidget)` e
  `observer.pushedNames` para verificar navegação.
- `emitState(tester, bloc, Estado())` emite um estado direto no bloc para
  alcançar ramos difíceis (loading, erros específicos, etc.).
- Textos: o `AppLocalization` de teste devolve a própria chave →
  `find.text('income_control_billets')`. Strings do `S` (flutter_intl) vêm em
  pt_BR de verdade.

## Armadilhas do testWidgets (fake async)
- NUNCA aguarde Hive, sqflite/drift, arquivos ou `Future.delayed` real fora de
  `tester.runAsync(...)`: o teste trava. Fluxos que passam pelo banco local
  (ex.: `MeLocalDataSource`, `LelloDatabase`) só completam dentro de
  `await tester.runAsync(() async { ...; await Future.delayed(50ms); })`.
- Não chame `bloc.close()` no teste (trava). Não é preciso fechar nada: o
  `tearDown` do harness reseta o container.
- "A Timer is still pending": algum `Timer`/`Future.delayed` da tela ficou
  pendente. Consuma com `await tester.pump(const Duration(seconds: N))` antes
  de terminar, ou navegue/desmonte (`await tester.pumpWidget(const SizedBox())`).
- `pumpAndSettle` estoura se houver animação infinita (`CircularProgressIndicator`
  em loading permanente): use `settle: false` + `tester.pump()`.
- Imagens de rede já são mockadas (PNG 1x1). `CachedNetworkImage` fica em
  loading; ignore.
- Overflows de layout viram exceções: use `surface: const Size(500, 1200)` em
  `pumpPage` se a tela precisar de mais espaço, ou `tester.takeException()`
  quando o overflow for do código de produção (documente como defeito).
- Widgets que resolvem dependências no construtor/initState precisam do
  harness instalado ANTES de `pumpPage` (o `setUp` já garante).
- Diálogos/bottom sheets: `await tester.tap(...)`; `await tester.pumpAndSettle()`;
  `find.byType(AlertDialog)`.
- Scroll: `await tester.scrollUntilVisible(finder, 200)` ou
  `tester.ensureVisible(finder)`.
- Plugins sem implementação no teste: `test/helpers/fake_url_launcher.dart`
  (`installFakeUrlLauncher()` registra URLs abertas) e
  `test/helpers/fake_local_auth.dart` (`installFakeLocalAuth()`); canais de
  método (ex. `in_app_review`, `com.example.app/url_launcher`) podem ser
  mockados com `setMockMethodCallHandler`.
- `MessageHandler`/notificações locais: veja `test/core/messaging/message_handler_test.dart`
  (mock do canal `dexterous.com/flutter/local_notifications`).

## O que cobrir em cada página
- Todos os estados do bloc (inicial, loading, vazio, carregado, erros) via
  respostas do `FakeHttp` e/ou `emitState`.
- Interações: taps em botões/cards/tabs, formulários (enterText + validação),
  navegação (rota e argumentos), voltar, retry.
- Widgets auxiliares (`presentation/widget/**`) diretamente com `pumpApp`
  (`test/helpers/pump_app.dart`) quando forem independentes do container.
- Pelo menos 1 golden por página principal da feature:
  `await expectLater(find.byType(MinhaPage), matchesGoldenFile('goldens/minha_page.png'))`
  (gere com `flutter test --update-goldens test/feature/<x>/<arq>_test.dart`).
