import 'dart:convert';

import 'package:essentials/analytics/analytics_timer.dart';
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

  AnalyticsTimer novoTimer({Map<String, String> extras = const {}}) =>
      AnalyticsTimer(
        userType: 'manager',
        userId: 'u-1',
        event: AnalyticsEvent('sindico_home_temporizador', 'y8298v', Type.read),
        referenceValue: 'cond-1',
        appOrigin: AppOriginEnum.manager,
        unitValue: 'apto 1',
        otherParameters: extras,
      );

  test('parar antes de 1 segundo não loga nada', () async {
    final timer = novoTimer();
    timer.stopTimer();
    expect(timer.getDuration().inMilliseconds, lessThan(1000));
    expect(fakeAnalytics.eventNames, isEmpty);
    expect(adjust.methods, isNot(contains('trackEvent')));
  });

  test('após 1 segundo loga duração, datas e horários no Firebase e no Adjust',
      () async {
    final timer = novoTimer(extras: {'tela': 'home'});
    // O timer usa DateTime.now() de verdade, então aguardamos tempo real.
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    timer.stopTimer();
    // logEvent é assíncrono e não é aguardado pelo stopTimer.
    await Future<void>.delayed(Duration.zero);

    expect(fakeAnalytics.eventNames, ['sindico_home_temporizador']);
    final params = fakeAnalytics.events['sindico_home_temporizador']!;
    expect(params['tipo'], 'read');
    expect(params['referencia'], 'cond-1');
    expect(params['unidade'], 'apto 1');
    expect(params['userId'], 'u-1');
    expect(params['userType'], 'manager');
    expect(params['tela'], 'home');
    expect(int.parse(params['durationInSeconds'] as String),
        inInclusiveRange(1, 2));
    expect(params['startDate'], matches(RegExp(r'^\d{1,2}/\d{1,2}/\d{4}$')));
    expect(params['endDate'], matches(RegExp(r'^\d{1,2}/\d{1,2}/\d{4}$')));
    expect(params['startHour'], matches(RegExp(r'^\d{2}:\d{2}:\d{2}$')));
    expect(params['endHour'], matches(RegExp(r'^\d{2}:\d{2}:\d{2}$')));

    final mapa = adjust.last('trackEvent')!.arguments as Map<Object?, Object?>;
    expect(mapa['eventToken'], 'y8298v');
    final callback =
        jsonDecode(mapa['callbackParameters'] as String) as Map<String, dynamic>;
    expect(callback['durationInSeconds'], params['durationInSeconds']);
    expect(callback['tela'], 'home');

    // Depois do stop o cronômetro recomeça (início e fim são dois
    // `DateTime.now()` distintos, então pode sobrar alguns microssegundos).
    expect(timer.getDuration().inMilliseconds, lessThan(50));
  });

  test('parâmetros padrão têm prioridade sobre os extras com o mesmo nome',
      () async {
    final timer = novoTimer(extras: {'userType': 'outro'});
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    timer.stopTimer();
    await Future<void>.delayed(Duration.zero);
    expect(fakeAnalytics.events['sindico_home_temporizador']!['userType'],
        'manager');
  });

  test('resetTimer zera a duração', () {
    final timer = novoTimer();
    timer.resetTimer();
    expect(timer.getDuration().inMilliseconds, lessThan(50));
  });

  /// Corrigido: `_endTime` é opcional; enquanto o timer não foi parado,
  /// `getDuration()`/`logEvent()` usam `DateTime.now()` como fim.
  test('getDuration e logEvent antes de stopTimer usam o agora como fim', () {
    final timer = novoTimer();
    expect(timer.getDuration().inMilliseconds,
        allOf(greaterThanOrEqualTo(0), lessThan(1000)));
    expect(() => timer.logEvent(), returnsNormally);
    expect(fakeAnalytics.eventNames, isEmpty,
        reason: 'menos de 1 segundo não loga');
  });

  test('logEvent antes de stopTimer loga com o agora como fim', () async {
    final timer = novoTimer();
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    timer.logEvent();
    final params = fakeAnalytics.events['sindico_home_temporizador']!;
    expect(params['durationInSeconds'], '1');
    expect(params['endHour'], isNotEmpty);
    expect(params['endDate'], isNotEmpty);
  });
}
