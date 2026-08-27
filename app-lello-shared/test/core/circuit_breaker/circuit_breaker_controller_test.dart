import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';
import 'package:shared_features/core/circuit_breaker/enum/circuit_breaker_situation_enum.dart';
import 'package:shared_features/core/circuit_breaker/models/circuit_item_rule.dart';

import '../../helpers/firebase_mocks.dart';
import '../core_test_support.dart';

class _Env extends Environment {
  _Env({bool production = false})
      : super(isProduction: production, apiUrl: 'http://x', name: 'teste');
}

/// Firestore que falha ao abrir a coleção (cobre o `catch` do construtor).
class _ThrowingFirestore extends Fake implements FirebaseFirestore {
  @override
  CollectionReference<Map<String, dynamic>> collection(String path) =>
      throw Exception('sem firestore');
}

Map<String, dynamic> rule(
  String name, {
  String situation = 'disabled',
  String message = 'Indisponível',
  List<String> excluded = const [],
  List<String> included = const [],
  String min = '',
  String max = '',
}) =>
    {
      'name': name,
      'disabledMessage': message,
      'excludedReferenceContext': excluded,
      'includedReferenceContext': included,
      'minimumVersion': min,
      'maximumVersion': max,
      'situation': situation,
    };

void main() {
  late FakeFirebaseFirestore db;
  late FakeCircuitSessionBloc session;

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
    session = FakeCircuitSessionBloc();
  });

  /// Cria o controller e aguarda o snapshot inicial: `dispose()` fecha o
  /// StreamController sem cancelar a inscrição no Firestore, então um
  /// snapshot que chegue depois do dispose lança (ver teste do defeito).
  Future<CircuitBreakerController> build({bool production = false}) async {
    final c = CircuitBreakerController(
      database: db,
      sessionBloc: session,
      environment: _Env(production: production),
    );
    await pumpEventQueue();
    return c;
  }

  group('stream do Firestore', () {
    test('em homologação escuta circuit_break_homolog e publica as regras',
        () async {
      final controller = await build();
      final emitted = <List<CircuitItemRule>>[];
      controller.ruleStream.stream.listen(emitted.add);
      await db.collection('circuit_break_homolog').add(rule('morar.boletos'));
      await db.collection('circuit_break').add(rule('ignorada'));
      await pumpEventQueue();

      expect(controller.listCircuitRules.map((r) => r.name), ['morar.boletos']);
      expect(emitted.last.single.situation,
          CircuitBreakerSituationEnum.disabled);
      expect(emitted.last.single.disabledMessage, 'Indisponível');
      controller.dispose();
      expect(controller.ruleStream.isClosed, isTrue);
    });

    test('em produção escuta circuit_break', () async {
      await db.collection('circuit_break').add(rule('morar.prod', situation: 'hide'));
      final controller = await build(production: true);
      await pumpEventQueue();
      expect(controller.listCircuitRules.single.name, 'morar.prod');
      expect(controller.listCircuitRules.single.situation,
          CircuitBreakerSituationEnum.hide);
      controller.dispose();
    });

    test('dispose não cancela a inscrição no Firestore', () async {
      /// Defeito: `dispose()` só fecha o `ruleStream`; a inscrição em
      /// `snapshots()` continua viva e o próximo snapshot faz
      /// `ruleStream.add` lançar "Cannot add new events after calling close".
      final errors = <Object>[];
      await runZonedGuarded(() async {
        final controller = CircuitBreakerController(
          database: db,
          sessionBloc: session,
          environment: _Env(),
        );
        controller.dispose();
        await pumpEventQueue();
        await db.collection('circuit_break_homolog').add(rule('depois'));
        await pumpEventQueue();
      }, (e, _) => errors.add(e));
      expect(errors, isNotEmpty);
      expect(errors.first, isA<StateError>());
    });

    test('falha ao abrir a coleção é registrada no Crashlytics sem quebrar',
        () async {
      final controller = CircuitBreakerController(
        database: _ThrowingFirestore(),
        sessionBloc: session,
        environment: _Env(),
      );
      expect(controller.listCircuitRules, isEmpty);
      expect(controller.opacityValue, isFalse);
      expect(controller.disableMessage, '');
      expect(CircuitBreakerController.DAFAULT_ACTION,
          CircuitBreakerSituationEnum.display);
      controller.dispose();
    });
  });

  group('CircuitItemRule.fromMap', () {
    test('converte todos os campos e o enum de situação', () async {
      await db.collection('c').add(rule(
            'x',
            situation: 'hide',
            excluded: ['0010', 'ab'],
            included: ['7'],
            min: '1.0.0',
            max: '3.0.0',
          ));
      final doc = (await db.collection('c').get()).docs.single;
      final r = CircuitItemRule.fromMap(doc);
      expect(r.name, 'x');
      expect(r.situation, CircuitBreakerSituationEnum.hide);
      expect(r.excludedReferenceContext, ['0010', 'ab']);
      expect(r.includedReferenceContext, ['7']);
      expect(r.minimumVersion, '1.0.0');
      expect(r.maximumVersion, '3.0.0');
    });

    test('situação desconhecida vira null e valores nulos viram padrão',
        () async {
      await db.collection('c').add({
        'name': null,
        'disabledMessage': null,
        'excludedReferenceContext': null,
        'includedReferenceContext': null,
        'minimumVersion': null,
        'maximumVersion': null,
        'situation': 'outra',
      });
      final doc = (await db.collection('c').get()).docs.single;
      final r = CircuitItemRule.fromMap(doc);
      expect(r.name, '');
      expect(r.disabledMessage, '');
      expect(r.excludedReferenceContext, isEmpty);
      expect(r.includedReferenceContext, isEmpty);
      expect(r.minimumVersion, '');
      expect(r.maximumVersion, '');
      expect(r.situation, isNull);
    });

    test('documento sem campos lança em vez de cair no fallback', () async {
      /// Defeito: `fromMap` captura só `on Exception`, mas campo ausente no
      /// documento lança `StateError` (um `Error`) e campo com tipo errado
      /// lança `TypeError`; o construtor vazio de fallback nunca é usado e o
      /// erro sobe até o listener do snapshot.
      await db.collection('c').add({'name': 'so-nome'});
      await db.collection('c').add(rule('tipo')..['situation'] = 5);
      final docs = (await db.collection('c').get()).docs;
      expect(() => CircuitItemRule.fromMap(docs[0]), throwsStateError);
      expect(() => CircuitItemRule.fromMap(docs[1]), throwsA(isA<TypeError>()));
    });
  });

  group('checkVersionInRange', () {
    late CircuitBreakerController c;
    setUp(() async => c = await build());
    tearDown(() => c.dispose());

    bool check(String current, String min, String max) =>
        c.checkVersionInRange(currentVersion: current, minVersion: min, maxVersion: max);

    test('sem limites está sempre no intervalo', () {
      expect(check('1.0.0', '', ''), isTrue);
    });

    test('só máximo', () {
      expect(check('1.9.9', '', '2.0.0'), isTrue);
      expect(check('2.0.1', '', '2.0.0'), isFalse);
      expect(check('2.0.0', '', '2.0.0'), isTrue);
      expect(check('2.0.0.1', '', '2.0.0'), isFalse);
      expect(check('2.0', '', '2.0.0'), isTrue);
    });

    test('só mínimo', () {
      expect(check('2.0.1', '1.0.0', ''), isTrue);
      expect(check('0.9.0', '1.0.0', ''), isFalse);
      expect(check('1.0.0', '1.0.0', ''), isTrue);
      /// Defeito: com versões iguais até o tamanho comparado, uma versão
      /// atual MAIS longa que a mínima (2.0.0.1 >= 2.0.0) é considerada fora
      /// do intervalo (`currentParts.length <= minParts.length`).
      expect(check('2.0.0.1', '2.0.0', ''), isFalse);
    });

    test('mínimo e máximo', () {
      expect(check('2.5.0', '2.0.0', '3.0.0'), isTrue);
      expect(check('1.9.0', '2.0.0', '3.0.0'), isFalse);
      /// Defeito: com mínimo e máximo, a comparação devolve true assim que
      /// uma parte é maior que a do mínimo, sem verificar as partes seguintes
      /// contra o máximo: 3.1.0 é aceito em [2.0.0, 3.0.0].
      expect(check('3.1.0', '2.0.0', '3.0.0'), isTrue);
      expect(check('4.0.0', '2.0.0', '3.0.0'), isFalse);
      expect(check('2.0.0', '2.0.0', '2.0.0'), isTrue);
      expect(check('2.0.5', '2.0', '2.1'), isTrue);
      expect(check('2.0.5', '2.0.0', '2.1'), isTrue); // máximo mais curto
      expect(check('2.2.0', '2.0.0', '2.1'), isFalse);
      expect(check('2', '2.0.0', '2.0.0'), isTrue);
    });
  });

  group('isAppVersionInRange', () {
    test('usa a versão do AppInfo', () async {
      final c = await build();
      expect(c.isAppVersionInRange(minVersion: '2.0.0', maxVersion: '3.0.0'),
          isTrue);
      expect(c.isAppVersionInRange(minVersion: '2.6.0', maxVersion: ''), isFalse);
      c.dispose();
    });

    test('versão não numérica é registrada no Crashlytics e devolve false',
        () async {
      final c = await build();
      expect(c.isAppVersionInRange(minVersion: 'abc', maxVersion: ''), isFalse);
      c.dispose();
    });
  });

  group('checkReferenceInList / checkReferenceNotInList', () {
    late CircuitBreakerController c;
    setUp(() async => c = await build());
    tearDown(() => c.dispose());

    test('lista vazia ou nula libera', () {
      expect(c.checkReferenceInList(list: null, reference: '1'), isTrue);
      expect(c.checkReferenceInList(list: [], reference: '1'), isTrue);
      expect(c.checkReferenceNotInList(list: null, reference: '1'), isTrue);
      expect(c.checkReferenceNotInList(list: [], reference: '1'), isTrue);
    });

    test('referência vazia com lista preenchida bloqueia', () {
      expect(c.checkReferenceInList(list: ['1'], reference: null), isFalse);
      expect(c.checkReferenceInList(list: ['1'], reference: ''), isFalse);
      expect(c.checkReferenceNotInList(list: ['1'], reference: null), isFalse);
      expect(c.checkReferenceNotInList(list: ['1'], reference: ''), isFalse);
    });

    test('compara numericamente ignorando zeros à esquerda e não dígitos', () {
      expect(c.checkReferenceInList(list: ['C-0012', '7'], reference: '0012'),
          isTrue);
      expect(c.checkReferenceInList(list: ['12'], reference: '13'), isFalse);
      expect(c.checkReferenceNotInList(list: ['12'], reference: '00012'),
          isFalse);
      expect(c.checkReferenceNotInList(list: ['12'], reference: '13'), isTrue);
      // referência sem dígitos vira 0
      expect(c.checkReferenceInList(list: ['abc'], reference: 'xyz'), isTrue);
    });
  });

  group('convertStringToEnum', () {
    test('converte disabled/hide e rejeita o resto', () async {
      final c = await build();
      expect(c.convertStringToEnum(situation: 'disabled'),
          CircuitBreakerSituationEnum.disabled);
      expect(c.convertStringToEnum(situation: 'hide'),
          CircuitBreakerSituationEnum.hide);
      expect(() => c.convertStringToEnum(situation: 'display'), throwsException);
      expect(() => c.convertStringToEnum(situation: null), throwsException);
      c.dispose();
    });
  });

  group('getRule', () {
    Future<CircuitBreakerController> withRules(
        List<Map<String, dynamic>> rules) async {
      for (final r in rules) {
        await db.collection('circuit_break_homolog').add(r);
      }
      final c = await build();
      await pumpEventQueue();
      return c;
    }

    test('sem regra com o nome devolve null', () async {
      final c = await withRules([rule('outra')]);
      expect(c.getRule(applicationRbac: 'morar.x', reference: '1'), isNull);
      c.dispose();
    });

    test('regra simples casa pelo nome', () async {
      final c = await withRules([rule('morar.x')]);
      expect(c.getRule(applicationRbac: 'morar.x', reference: null)?.name,
          'morar.x');
      c.dispose();
    });

    test('referência excluída ou não incluída devolve null', () async {
      final c = await withRules([
        rule('morar.exc', excluded: ['10']),
        rule('morar.inc', included: ['20']),
      ]);
      expect(c.getRule(applicationRbac: 'morar.exc', reference: '0010'), isNull);
      expect(c.getRule(applicationRbac: 'morar.exc', reference: '11'), isNotNull);
      expect(c.getRule(applicationRbac: 'morar.inc', reference: '20'), isNotNull);
      expect(c.getRule(applicationRbac: 'morar.inc', reference: '21'), isNull);
      c.dispose();
    });

    test('versão do app fora do intervalo devolve null', () async {
      final c = await withRules([
        rule('morar.v', min: '3.0.0'),
        rule('morar.ok', min: '2.0.0', max: '2.9.9'),
      ]);
      expect(c.getRule(applicationRbac: 'morar.v', reference: '1'), isNull);
      expect(c.getRule(applicationRbac: 'morar.ok', reference: '1'), isNotNull);
      c.dispose();
    });
  });

  group('checkVisible', () {
    test('regra hide esconde', () async {
      await db.collection('circuit_break_homolog').add(rule('morar.h', situation: 'hide'));
      final c = await build();
      await pumpEventQueue();
      expect(c.checkVisible(applicationRbac: 'morar.h', reference: '1'), isFalse);
      c.dispose();
    });

    test('sem RBAC esconde; com RBAC mostra', () async {
      final c = await build();
      session.rbacAllowed = false;
      expect(c.checkVisible(applicationRbac: 'morar.a', reference: '1'), isFalse);
      session.rbacAllowed = true;
      expect(c.checkVisible(applicationRbac: 'morar.a', reference: '1'), isTrue);
      expect(session.checkedRbacs, ['morar.a', 'morar.a']);
      c.dispose();
    });

    test('hasHortaCheck depende do remote config da horta', () async {
      final c = await build();
      expect(
          c.checkVisible(
              applicationRbac: 'morar.a', reference: '1', hasHortaCheck: true),
          isFalse);
      session.horta = {'ativo': true};
      expect(
          c.checkVisible(
              applicationRbac: 'morar.a', reference: '1', hasHortaCheck: true),
          isTrue);
      c.dispose();
    });
  });
}
