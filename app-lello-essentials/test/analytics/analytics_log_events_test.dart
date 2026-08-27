import 'dart:convert';

import 'package:essentials/analytics/analytics_log_events.dart';
import 'package:essentials/analytics/events/analytics_event.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/firebase_mocks.dart';
import 'adjust_channel.dart';

void main() {
  late AdjustChannelRecorder adjust;

  setUp(() async {
    await setUpFakeFirebase();
    adjust = installAdjustRecorder();
  });

  final evento = AnalyticsEvent('despesas_acessar', '2gbbeo', Type.read);

  test('loga no Firebase só com o tipo quando os opcionais estão vazios',
      () async {
    await AnalyticsLogEvents.logEvent(
      event: evento,
      referenceValue: '',
      appOrigin: AppOriginEnum.manager,
      unitValue: '',
      userId: '',
      userType: '',
    );

    expect(fakeAnalytics.eventNames, ['despesas_acessar']);
    expect(fakeAnalytics.events['despesas_acessar'], {'tipo': 'read'});
  });

  test('inclui referência, unidade, usuário, tipo de usuário e extras',
      () async {
    await AnalyticsLogEvents.logEvent(
      event: evento,
      referenceValue: 'cond-1',
      appOrigin: AppOriginEnum.owner,
      unitValue: 'apto 12',
      userId: 'user-9',
      userType: 'owner',
      otherParameters: {'origem': 'home'},
    );

    expect(fakeAnalytics.events['despesas_acessar'], {
      'tipo': 'read',
      'referencia': 'cond-1',
      'unidade': 'apto 12',
      'userId': 'user-9',
      'userType': 'owner',
      'origem': 'home',
    });
  });

  test('opcionais nulos são ignorados', () async {
    await AnalyticsLogEvents.logEvent(
      event: AnalyticsEvent('login_finalizado', 'jw7o8k', Type.write),
      referenceValue: 'ref',
      appOrigin: AppOriginEnum.employee,
    );
    expect(fakeAnalytics.events['login_finalizado'],
        {'tipo': 'write', 'referencia': 'ref'});
  });

  test('parâmetros extras podem sobrescrever os padrão', () async {
    await AnalyticsLogEvents.logEvent(
      event: evento,
      referenceValue: 'ref',
      appOrigin: AppOriginEnum.manager,
      otherParameters: {'tipo': 'custom'},
    );
    expect(fakeAnalytics.events['despesas_acessar'],
        {'tipo': 'custom', 'referencia': 'ref'});
  });

  test('replica o evento no Adjust com os mesmos parâmetros', () async {
    await AnalyticsLogEvents.logEvent(
      event: evento,
      referenceValue: 'cond-1',
      appOrigin: AppOriginEnum.manager,
      userId: 'u1',
    );

    final call = adjust.last('trackEvent');
    expect(call, isNotNull);
    final mapa = call!.arguments as Map<Object?, Object?>;
    expect(mapa['eventToken'], '2gbbeo');
    expect(jsonDecode(mapa['callbackParameters'] as String),
        {'tipo': 'read', 'referencia': 'cond-1', 'userId': 'u1'});
  });

  test('evento sem token vai só para o Firebase', () async {
    await AnalyticsLogEvents.logEvent(
      event: AnalyticsEvent('sem_token', '', Type.read),
      referenceValue: '',
      appOrigin: AppOriginEnum.owner,
    );
    expect(fakeAnalytics.eventNames, ['sem_token']);
    expect(adjust.methods, isNot(contains('trackEvent')));
  });

  test('erro do Firebase (nome reservado) é engolido e não chega ao Adjust',
      () async {
    // O prefixo "firebase_" é reservado e o plugin lança ArgumentError.
    await AnalyticsLogEvents.logEvent(
      event: AnalyticsEvent('firebase_reservado', 'abc123', Type.read),
      referenceValue: 'ref',
      appOrigin: AppOriginEnum.owner,
    );

    expect(fakeAnalytics.eventNames, isEmpty);
    expect(adjust.methods, isNot(contains('trackEvent')));
  });
}
