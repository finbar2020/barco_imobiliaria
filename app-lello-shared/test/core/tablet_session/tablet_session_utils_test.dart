import 'dart:io';

import 'package:essentials/enum/app_origin_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

void main() {
  late Directory dir;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('shared_tablet_session');
    Hive.init(dir.path);
  });

  tearDown(() async {
    await Hive.close();
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });

  group('getIsTabletSession', () {
    test('só o app colaborador (employee) pode ter sessão de tablet', () async {
      expect(await TabletSessionUtils.getIsTabletSession(AppOriginEnum.owner),
          isFalse);
      expect(await TabletSessionUtils.getIsTabletSession(AppOriginEnum.manager),
          isFalse);
      expect(await TabletSessionUtils.getIsTabletSession(null), isFalse);
      expect(
          await TabletSessionUtils.getIsTabletSession(AppOriginEnum.employee),
          isFalse);
    });

    test('é verdadeiro quando há código de condomínio gravado', () async {
      await TabletSessionUtils.setCondoCode('0123');
      expect(
          await TabletSessionUtils.getIsTabletSession(AppOriginEnum.employee),
          isTrue);
      expect(await TabletSessionUtils.getCondoCode(), '0123');

      await TabletSessionUtils.removeIsTabletSession();
      expect(
          await TabletSessionUtils.getIsTabletSession(AppOriginEnum.employee),
          isFalse);
      expect(await TabletSessionUtils.getCondoCode(), isNull);
    });
  });

  group('condoCode', () {
    test('setCondoCode limpa o anterior e getCondoCode devolve o atual',
        () async {
      expect(await TabletSessionUtils.getCondoCode(), isNull);
      await TabletSessionUtils.setCondoCode('A');
      await TabletSessionUtils.setCondoCode('B');
      expect(await TabletSessionUtils.getCondoCode(), 'B');
      final box = await Hive.openBox(SharedPreferencesKeys.isTabletSession);
      expect(box.length, 1);
    });
  });

  group('sessionStartDate', () {
    test('sem data gravada devolve null e a sessão é inválida', () async {
      expect(await TabletSessionUtils.getTabletSessionStartDate(), isNull);
      expect(
          await TabletSessionUtils.checkValidTabletSession(
              const Duration(hours: 1)),
          isFalse);
    });

    test('grava e lê a data em ISO 8601', () async {
      final start = DateTime(2026, 8, 27, 9, 15);
      await TabletSessionUtils.setTabletSessionStartDate(start);
      expect(await TabletSessionUtils.getTabletSessionStartDate(), start);
      final box = await Hive.openBox(SharedPreferencesKeys.sessionStartDate);
      expect(box.get(SharedPreferencesKeys.sessionStartDate),
          start.toIso8601String());
    });

    test('setTabletSessionStartDate(null) limpa a data', () async {
      await TabletSessionUtils.setTabletSessionStartDate(DateTime(2026));
      await TabletSessionUtils.setTabletSessionStartDate(null);
      expect(await TabletSessionUtils.getTabletSessionStartDate(), isNull);
    });

    test('valor inválido gravado devolve null', () async {
      /// Corrigido: `if (dateString == null || dateString.isEmpty)` devolve
      /// null direto para valor ausente ou vazio; texto inválido continua
      /// caindo no `catch` do `DateTime.parse`.
      final box = await Hive.openBox(SharedPreferencesKeys.sessionStartDate);
      await box.put(SharedPreferencesKeys.sessionStartDate, 'nao-e-data');
      expect(await TabletSessionUtils.getTabletSessionStartDate(), isNull);
      await box.put(SharedPreferencesKeys.sessionStartDate, '');
      expect(await TabletSessionUtils.getTabletSessionStartDate(), isNull);
    });

    test('checkValidTabletSession respeita a duração máxima', () async {
      await TabletSessionUtils.setTabletSessionStartDate(
          DateTime.now().subtract(const Duration(minutes: 30)));
      expect(
          await TabletSessionUtils.checkValidTabletSession(
              const Duration(hours: 1)),
          isTrue);
      expect(
          await TabletSessionUtils.checkValidTabletSession(
              const Duration(minutes: 10)),
          isFalse);
    });
  });
}
