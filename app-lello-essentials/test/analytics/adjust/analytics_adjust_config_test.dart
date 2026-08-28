import 'dart:convert';

import 'package:adjust_sdk/adjust_config.dart';
import 'package:essentials/analytics/adjust/analytics_adjust_config.dart';
import 'package:essentials/analytics/events/analytics_event.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/firebase_mocks.dart';
import '../adjust_channel.dart';

void main() {
  late AdjustChannelRecorder adjust;

  setUp(() async {
    await setUpFakeFirebase();
    adjust = installAdjustRecorder();
  });

  group('initPlatformState', () {
    Future<Map<Object?, Object?>> init(AppOriginEnum origem,
        {AdjustEnvironment ambiente = AdjustEnvironment.sandbox}) async {
      await AnalyticsAdjustConfig.initPlatformState(
        appOriginEnum: origem,
        adjustEnvironment: ambiente,
      );
      final call = adjust.last('initSdk');
      expect(call, isNotNull, reason: 'initSdk deve ser enviado ao nativo');
      return call!.arguments as Map<Object?, Object?>;
    }

    test('síndico usa o token do app do síndico', () async {
      final config = await init(AppOriginEnum.manager);
      expect(config['appToken'], 'm80e1uxzam80');
      expect(config['environment'], 'sandbox');
      expect(config['logLevel'], 'verbose');
    });

    test('morador usa o token do app do morador em produção', () async {
      final config = await init(AppOriginEnum.owner,
          ambiente: AdjustEnvironment.production);
      expect(config['appToken'], 'bupp99brj6rk');
      expect(config['environment'], 'production');
    });

    test('colaborador usa o token do app do colaborador', () async {
      final config = await init(AppOriginEnum.employee);
      expect(config['appToken'], 'kx9jjsx9ghkw');
    });

    test('registra todos os callbacks de atribuição, sessão, evento e deeplink',
        () async {
      final config = await init(AppOriginEnum.manager);
      expect(config['attributionCallback'], 'adj-attribution-changed');
      expect(config['sessionSuccessCallback'], 'adj-session-success');
      expect(config['sessionFailureCallback'], 'adj-session-failure');
      expect(config['eventSuccessCallback'], 'adj-event-success');
      expect(config['eventFailureCallback'], 'adj-event-failure');
      expect(config['deferredDeeplinkCallback'], 'adj-deferred-deeplink');
    });
  });

  group('callbacks vindos do nativo', () {
    setUp(() async {
      await AnalyticsAdjustConfig.initPlatformState(
        appOriginEnum: AppOriginEnum.owner,
        adjustEnvironment: AdjustEnvironment.sandbox,
      );
    });

    const atribuicaoCompleta = {
      'trackerToken': 'tok',
      'trackerName': 'nome',
      'campaign': 'campanha',
      'network': 'rede',
      'creative': 'criativo',
      'adgroup': 'grupo',
      'clickLabel': 'rotulo',
      'costType': 'cpi',
      'costAmount': '1.5',
      'costCurrency': 'BRL',
    };

    test('atribuição com todos os campos e sem nenhum não lança', () async {
      await adjust.emitFromNative('adj-attribution-changed', atribuicaoCompleta);
      await adjust.emitFromNative('adj-attribution-changed', <String, String>{});
    });

    test('sucesso e falha de sessão com e sem campos', () async {
      await adjust.emitFromNative('adj-session-success', {
        'message': 'ok',
        'timestamp': '2026-01-01',
        'adid': 'adid',
        'jsonResponse': '{}',
      });
      await adjust.emitFromNative('adj-session-success', <String, String>{});
      await adjust.emitFromNative('adj-session-failure', {
        'message': 'falhou',
        'timestamp': '2026-01-01',
        'adid': 'adid',
        'willRetry': 'true',
        'jsonResponse': '{}',
      });
      await adjust.emitFromNative('adj-session-failure', <String, String>{});
    });

    test('sucesso e falha de evento com e sem campos', () async {
      await adjust.emitFromNative('adj-event-success', {
        'eventToken': 'abc123',
        'message': 'ok',
        'timestamp': '2026-01-01',
        'adid': 'adid',
        'callbackId': 'cb',
        'jsonResponse': '{}',
      });
      await adjust.emitFromNative('adj-event-success', <String, String>{});
      await adjust.emitFromNative('adj-event-failure', {
        'eventToken': 'abc123',
        'message': 'falhou',
        'timestamp': '2026-01-01',
        'adid': 'adid',
        'callbackId': 'cb',
        'willRetry': 'false',
        'jsonResponse': '{}',
      });
      await adjust.emitFromNative('adj-event-failure', <String, String>{});
    });

    test('deeplink adiado é logado', () async {
      await adjust.emitFromNative(
          'adj-deferred-deeplink', {'deeplink': 'lello://home'});
    });

    /// Corrigido: `deferredDeeplinkCallback` trata `uri` nulo sem `!`; um
    /// deeplink nulo vindo do nativo é apenas logado.
    test('deeplink adiado nulo não lança', () async {
      await adjust.emitFromNative('adj-deferred-deeplink', {'deeplink': null});
    });
  });

  group('logAdjustEvent', () {
    test('envia trackEvent com token e parâmetros de callback', () {
      AnalyticsAdjustConfig.logAdjustEvent(
        event: AnalyticsEvent('evento', 'tok123', Type.read),
        appOrigin: AppOriginEnum.manager,
        parameters: {'tipo': 'read', 'referencia': '42'},
      );
      final call = adjust.last('trackEvent');
      expect(call, isNotNull);
      final mapa = call!.arguments as Map<Object?, Object?>;
      expect(mapa['eventToken'], 'tok123');
      expect(jsonDecode(mapa['callbackParameters'] as String),
          {'tipo': 'read', 'referencia': '42'});
    });

    test('sem parâmetros envia só o token', () {
      AnalyticsAdjustConfig.logAdjustEvent(
        event: AnalyticsEvent('evento', 'tok123', Type.read),
        appOrigin: AppOriginEnum.owner,
        parameters: const {},
      );
      final mapa = adjust.last('trackEvent')!.arguments as Map<Object?, Object?>;
      expect(mapa.containsKey('callbackParameters'), isFalse);
    });

    test('token vazio não envia nada ao Adjust', () {
      AnalyticsAdjustConfig.logAdjustEvent(
        event: AnalyticsEvent('evento', '', Type.read),
        appOrigin: AppOriginEnum.employee,
        parameters: {'tipo': 'read'},
      );
      expect(adjust.methods, isNot(contains('trackEvent')));
    });
  });
}
