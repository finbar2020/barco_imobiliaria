import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';
import 'package:shared_features/core/circuit_breaker/enum/circuit_breaker_situation_enum.dart';
import 'package:shared_features/core/circuit_breaker/models/circuit_item_rule.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_modal_disable_messager.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/test_container.dart';
import '../core_test_support.dart';

class _Env extends Environment {
  _Env() : super(isProduction: false, apiUrl: 'http://x', name: 'teste');
}

void main() {
  late FakeFirebaseFirestore db;
  late TestSharedContainer container;
  late CircuitBreakerController controller;

  setUpAll(() async {
    await setUpFakeFirebase();
    PackageInfo.setMockInitialValues(
      appName: 'lello',
      packageName: 'br.com.lello',
      version: '2.5.0',
      buildNumber: '1',
      buildSignature: '',
    );
    await AppInfo.init();
  });

  setUp(() {
    db = FakeFirebaseFirestore();
    container = TestSharedContainer();
    fakeAnalytics.reset();
  });

  tearDown(() => controller.dispose());

  /// Grava as regras e cria o controller já com elas carregadas.
  Future<void> install(WidgetTester tester, List<Map<String, dynamic>> rules) async {
    await tester.runAsync(() async {
      for (final r in rules) {
        await db.collection('circuit_break_homolog').add(r);
      }
      controller = CircuitBreakerController(
        database: db,
        sessionBloc: FakeCircuitSessionBloc(),
        environment: _Env(),
      );
      await pumpEventQueue();
    });
    container.register<CircuitBreakerController>(controller);
  }

  Map<String, dynamic> rule(String name, String situation, {String? message}) => {
        'name': name,
        'disabledMessage': message,
        'excludedReferenceContext': [],
        'includedReferenceContext': [],
        'minimumVersion': '',
        'maximumVersion': '',
        'situation': situation,
      };

  Widget widget({bool rbacEnabled = true, String? reference = '123'}) =>
      CircuitBreakerWidget(
        applicationRbac: 'morar.teste',
        reference: reference,
        appContainer: container,
        rbacEnabled: rbacEnabled,
        child: const Text('conteudo', key: Key('filho')),
      );

  testWidgets('rbacEnabled false não renderiza nada nem resolve o controller',
      (tester) async {
    await install(tester, []);
    await pumpApp(tester, widget(rbacEnabled: false));
    expect(find.byKey(const Key('filho')), findsNothing);
    expect(find.byType(StreamBuilder<List<CircuitItemRule>>), findsNothing);
  });

  testWidgets('sem regra mostra o filho normalmente', (tester) async {
    await install(tester, [rule('outro.rbac', 'hide')]);
    await pumpApp(tester, widget());
    expect(find.byKey(const Key('filho')), findsOneWidget);
    expect(find.byType(Opacity), findsNothing);
    expect(find.byType(InkWell), findsNothing);
  });

  testWidgets('regra display mostra o filho', (tester) async {
    await install(tester, [rule('morar.teste', 'display')]);
    await pumpApp(tester, widget());
    expect(find.byKey(const Key('filho')), findsOneWidget);
    expect(find.byType(Opacity), findsNothing);
  });

  testWidgets('regra hide esconde o filho', (tester) async {
    await install(tester, [rule('morar.teste', 'hide')]);
    await pumpApp(tester, widget());
    expect(find.byKey(const Key('filho')), findsNothing);
  });

  testWidgets('regra chega pelo stream depois de montado', (tester) async {
    await install(tester, []);
    await pumpApp(tester, widget());
    expect(find.byKey(const Key('filho')), findsOneWidget);
    await tester.runAsync(() async {
      await db.collection('circuit_break_homolog').add(rule('morar.teste', 'hide'));
      await pumpEventQueue();
    });
    await tester.pump();
    expect(find.byKey(const Key('filho')), findsNothing);
  });

  testWidgets(
      'regra disabled deixa o filho opaco e o toque registra evento e abre o modal',
      (tester) async {
    await install(tester, [rule('morar.teste', 'disabled', message: 'Volte amanhã')]);
    await pumpPage(tester, Scaffold(body: widget()),
        providers: withFakeAssets);
    expect(find.byKey(const Key('filho')), findsOneWidget);
    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 0.5);
    expect(tester.widget<IgnorePointer>(find.byType(IgnorePointer).last).ignoring,
        isTrue);

    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    expect(fakeAnalytics.eventNames, ['circuit_breaker_disabled']);
    expect(fakeAnalytics.events['circuit_breaker_disabled'], {
      'application_rbac': 'morar.teste',
      'reference': '123',
      'disabled_message': 'Volte amanhã',
    });
    expect(find.byType(CircuitBreakerModalDisableMessager), findsOneWidget);
    expect(find.text('circuit_breaker_widget_title!'), findsOneWidget);
    expect(find.text('Volte amanhã'), findsOneWidget);

    await tester.tap(find.text('circuit_breaker_widget_close'));
    await tester.pumpAndSettle();
    expect(find.byType(CircuitBreakerModalDisableMessager), findsNothing);
  });

  testWidgets('sem referência nem mensagem o evento só leva o rbac',
      (tester) async {
    await install(tester, [rule('morar.teste', 'disabled')]);
    await pumpPage(tester, Scaffold(body: widget(reference: null)),
        providers: withFakeAssets);
    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();
    // disabledMessage null no Firestore vira "" no modelo (`?? ""`): o
    // evento leva a mensagem vazia e o modal mostra "" em vez do texto padrão.
    expect(fakeAnalytics.events['circuit_breaker_disabled'],
        {'application_rbac': 'morar.teste', 'disabled_message': ''});
    expect(find.byType(CircuitBreakerModalDisableMessager), findsOneWidget);
    expect(find.text('circuit_breaker_default_message'), findsNothing);
    expect(find.text(''), findsOneWidget);
  });

  group('CircuitBreakerModalDisableMessager', () {
    testWidgets('usa os textos padrão quando título e mensagem são nulos',
        (tester) async {
      await pumpApp(
        tester,
        withFakeAssets(
            CircuitBreakerModalDisableMessager(title: null, message: null)),
      );
      expect(find.text('circuit_breaker_widget_title!'), findsOneWidget);
      expect(find.text('circuit_breaker_default_message'), findsOneWidget);
      expect(find.text('circuit_breaker_widget_close'), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);
      await expectLater(findGoldenSurface(),
          matchesGoldenFile('goldens/circuit_breaker_modal_default.png'));
    });

    testWidgets('mostra título e mensagem informados e fecha ao tocar',
        (tester) async {
      final observer = RecordingNavigatorObserver();
      await pumpPage(
        tester,
        Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => showModalBottomSheet(
                context: context,
                builder: (_) => CircuitBreakerModalDisableMessager(
                    title: 'Título X', message: 'Mensagem Y'),
              ),
              child: const Text('abrir'),
            ),
          ),
        ),
        observer: observer,
        providers: withFakeAssets,
      );
      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();
      expect(find.text('Título X'), findsOneWidget);
      expect(find.text('Mensagem Y'), findsOneWidget);
      await tester.tap(find.text('circuit_breaker_widget_close'));
      await tester.pumpAndSettle();
      expect(observer.popped, hasLength(1));
      expect(find.text('Título X'), findsNothing);
    });
  });

  test('CircuitBreakerSituationEnum tem as três situações', () {
    expect(CircuitBreakerSituationEnum.values, [
      CircuitBreakerSituationEnum.disabled,
      CircuitBreakerSituationEnum.hide,
      CircuitBreakerSituationEnum.display,
    ]);
  });
}
