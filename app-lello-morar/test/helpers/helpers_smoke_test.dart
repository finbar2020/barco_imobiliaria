import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/database/lello_database.dart';

import 'firebase_mocks.dart';
import 'fixtures.dart';
import 'init_sqflite_ffi.dart';
import 'pump_app.dart';

void main() {
  setUpAll(() async {
    await setUpFakeFirebase(remoteConfigValues: {'k': 'v'});
    initSqfliteForTests();
  });

  test('fixtures montam uma sessão consistente', () {
    final session = testSession();
    expect(session.condominium!.id, 'c1');
    expect(session.unity!.id, 'u1');
    expect(session.tokenName, 'R1101');
    final bloc = FakeSessionBloc();
    expect(bloc.checkRback('x'), isTrue);
    expect(bloc.rbacChecked, ['x']);
  });

  test('analytics falso registra eventos', () async {
    await FirebaseAnalytics.instance.logEvent(name: 'e1', parameters: {'a': 1});
    expect(fakeAnalytics.eventNames, ['e1']);
  });

  test('banco drift abre em pasta temporária', () async {
    final db = LelloDatabase();
    expect(await db.meDao.get(), isNull);
    await db.close();
  });

  testWidgets('pumpApp renderiza com localização', (tester) async {
    await pumpApp(tester, const Text('olá'), localized: true);
    expect(find.text('olá'), findsOneWidget);
  });
}
