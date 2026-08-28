import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:shared_features/core/database/banners/banners_args_dao.dart';
import 'package:shared_features/core/database/banners/banners_args_hive_model.dart';
import 'package:shared_features/core/database/banners/banners_dao.dart';
import 'package:shared_features/core/database/banners/banners_hive_model.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

BannersHive _banner(String id, String condo, {String? feature}) => BannersHive()
  ..id = id
  ..condominiumId = condo
  ..image = 'img_$id.png'
  ..feature = feature;

BannersArgsHiveModel _args(String bannerId, String condo, {String? partner}) =>
    BannersArgsHiveModel()
      ..bannerId = bannerId
      ..condominiumId = condo
      ..partnerId = partner;

void main() {
  late Directory dir;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('shared_banners_hive');
    Hive.init(dir.path);
  });

  tearDown(() async {
    await Hive.close();
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });

  group('BannersDao', () {
    test('registra o adaptador uma única vez e abre a caixa de banners',
        () async {
      final dao = BannersDao();
      final box = await dao.box;
      expect(box.name, SharedPreferencesKeys.banners.toLowerCase());
      expect(Hive.isAdapterRegistered(BannersHiveAdapter().typeId), isTrue);
      // Segunda chamada não tenta registrar de novo (registrar duas vezes
      // lançaria HiveError).
      expect(await dao.box, same(box));
    });

    test('insert/get filtram por condomínio e clear remove só do condomínio',
        () async {
      final dao = BannersDao();
      await dao.insert(_banner('b1', 'c1', feature: 'morar'));
      await dao.insert(_banner('b2', 'c1'));
      await dao.insert(_banner('b3', 'c2'));

      final c1 = await dao.get('c1');
      expect(c1.map((b) => b.id), ['b1', 'b2']);
      expect(c1.first.image, 'img_b1.png');
      expect(c1.first.feature, 'morar');
      expect(await dao.get('c2'), hasLength(1));
      expect(await dao.get('c3'), isEmpty);

      // insert com o mesmo id substitui
      await dao.insert(_banner('b1', 'c1', feature: 'viver'));
      expect((await dao.get('c1')).first.feature, 'viver');
      expect(await dao.get('c1'), hasLength(2));

      await dao.clear('c1');
      expect(await dao.get('c1'), isEmpty);
      expect(await dao.get('c2'), hasLength(1));
      await dao.clear('inexistente');
      expect(await dao.get('c2'), hasLength(1));
    });

    test('todos os campos sobrevivem à escrita e leitura em disco', () async {
      final dao = BannersDao();
      final full = _banner('full', 'c9')
        ..redirect = 'https://x'
        ..redirectType = 'url'
        ..urlImage = 'https://img'
        ..lastUpdateAt = DateTime(2026, 8, 1, 10, 30)
        ..name = 'Nome'
        ..observacao = 'Obs'
        ..location = 'home'
        ..subTitle = 'Sub'
        ..typeBanner = 'tipo'
        ..projeto = 'proj'
        ..ordem = 3
        ..ativo = 'S';
      await dao.insert(full);
      await Hive.close();
      Hive.init(dir.path);

      final read = (await BannersDao().get('c9')).single;
      expect(read.id, 'full');
      expect(read.condominiumId, 'c9');
      expect(read.redirect, 'https://x');
      expect(read.redirectType, 'url');
      expect(read.image, 'img_full.png');
      expect(read.urlImage, 'https://img');
      expect(read.feature, isNull);
      expect(read.lastUpdateAt, DateTime(2026, 8, 1, 10, 30));
      expect(read.name, 'Nome');
      expect(read.observacao, 'Obs');
      expect(read.location, 'home');
      expect(read.subTitle, 'Sub');
      expect(read.typeBanner, 'tipo');
      expect(read.projeto, 'proj');
      expect(read.ordem, 3);
      expect(read.ativo, 'S');
    });

    test('adaptador gerado: typeId, igualdade e hashCode', () {
      final a = BannersHiveAdapter();
      expect(a.typeId, 1);
      expect(a, equals(BannersHiveAdapter()));
      expect(a.hashCode, a.typeId.hashCode);
      expect(a == Object(), isFalse);
    });
  });

  group('BannersArgsDao', () {
    test('abre a caixa de argumentos registrando o adaptador', () async {
      final dao = BannersArgsDao();
      final box = await dao.box;
      expect(box.name, SharedPreferencesKeys.bannersArgs.toLowerCase());
      expect(await dao.box, same(box));
      expect(Hive.isAdapterRegistered(BannersArgsHiveModelAdapter().typeId),
          isTrue);
    });

    test('insert, getByBannerId, getByCondominiumId e clearByCondominium',
        () async {
      final dao = BannersArgsDao();
      await dao.insert(_args('b1', 'c1', partner: 'p1'));
      await dao.insert(_args('b2', 'c1'));
      await dao.insert(_args('b3', 'c2', partner: 'p3'));

      final b1 = await dao.getByBannerId('b1');
      expect(b1?.partnerId, 'p1');
      expect(b1?.condominiumId, 'c1');
      expect(await dao.getByBannerId('nao-existe'), isNull);
      expect((await dao.getByCondominiumId('c1')).map((e) => e.bannerId),
          ['b1', 'b2']);
      expect(await dao.getByCondominiumId('c3'), isEmpty);

      await dao.clearByCondominium('c1');
      expect(await dao.getByCondominiumId('c1'), isEmpty);
      expect(await dao.getByBannerId('b3'), isNotNull);
    });

    test('persiste em disco e relê pelo adaptador gerado', () async {
      await BannersArgsDao().insert(_args('bx', 'cx', partner: 'px'));
      await Hive.close();
      Hive.init(dir.path);
      final read = await BannersArgsDao().getByBannerId('bx');
      expect(read?.condominiumId, 'cx');
      expect(read?.partnerId, 'px');

      final a = BannersArgsHiveModelAdapter();
      expect(a.typeId, 0);
      expect(a, equals(BannersArgsHiveModelAdapter()));
      expect(a.hashCode, 0.hashCode);
      expect(a == Object(), isFalse);
    });

    test('getByBannerId devolve null quando a caixa falha', () async {
      // A caixa já aberta sem tipo faz o `openBox<BannersArgsHiveModel>`
      // lançar HiveError; o DAO engole o erro e devolve null.
      await Hive.openBox(SharedPreferencesKeys.bannersArgs);
      final dao = BannersArgsDao();
      expect(await dao.getByBannerId('b1'), isNull);
      expect(() => dao.getByCondominiumId('c1'), throwsA(isA<HiveError>()));
    });
  });
}
