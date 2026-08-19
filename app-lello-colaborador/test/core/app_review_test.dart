import 'package:colaborador/core/app_review/app_review.dart';
import 'package:essentials/essentials.dart' hide isNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/firebase_mocks.dart';
import '../helpers/pump_app.dart';
import '../helpers/test_application_container.dart';

/// `AppReview.call` só decide o intervalo e repassa para o diálogo do
/// essentials, que é inofensivo em teste (o in-app review não está
/// disponível).
Future<void> _callWith(WidgetTester tester, FirebaseRemoteConfig? remote) async {
  final scope = await installTestApplicationContainer(remoteConfig: remote);
  addTearDown(scope.dispose);

  await pumpApp(
    tester,
    Builder(
      builder: (context) => TextButton(
        onPressed: () => AppReview.call(context: context),
        child: const Text('avaliar'),
      ),
    ),
    settle: false,
  );

  await tester.tap(find.text('avaliar'));
  await tester.pump();
}

void main() {
  tearDown(resetTestApplicationContainer);

  testWidgets('sem remote config usa o intervalo padrão', (tester) async {
    await _callWith(tester, null);

    expect(tester.takeException(), isNull);
  });

  testWidgets('lê o intervalo configurado no remote config', (tester) async {
    await setUpFakeFirebase(
      remoteConfigValues: {
        CustomFirebaseRemoteConfig.reviewAppInterval: '3600000',
      },
    );

    await _callWith(tester, FirebaseRemoteConfig.instance);

    expect(tester.takeException(), isNull);
    expect(
      FirebaseRemoteConfig.instance
          .getString(CustomFirebaseRemoteConfig.reviewAppInterval),
      '3600000',
    );
  });

  testWidgets('intervalo inválido não quebra a chamada', (tester) async {
    await setUpFakeFirebase(
      remoteConfigValues: {
        CustomFirebaseRemoteConfig.reviewAppInterval: 'nao-e-numero',
      },
    );

    await _callWith(tester, FirebaseRemoteConfig.instance);

    expect(tester.takeException(), isNull);
  });
}
