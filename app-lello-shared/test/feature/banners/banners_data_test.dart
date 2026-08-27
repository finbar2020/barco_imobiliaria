import 'dart:io';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/core/database/banners/banners_dao.dart';
import 'package:shared_features/core/database/banners/banners_hive_model.dart';
import 'package:shared_features/feature/banners/domain/entity/banner.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_redirect_type_enum.dart';
import 'package:shared_features/feature/banners/domain/use_case/get_banners/get_banners.dart';

import '../../helpers/firebase_mocks.dart';
import 'banners_support.dart';

void main() {
  group('BannersLocalDataSourceImpl (Hive real)', () {
    late Directory dir;

    setUp(() {
      dir = initHiveTemp();
    });

    tearDown(() => disposeHive(dir));

    test('save grava banners e args; select devolve com args', () async {
      final local = hiveLocalDataSource();
      final saved = await local.save(
          [buildBannerModel(id: 'b1'), buildBannerModel(id: 'b2', partnerId: null)],
          'C1');
      expect(saved, hasLength(2));

      final banners = await local.select('C1');
      expect(banners.map((b) => b.id), ['b1', 'b2']);
      final b1 = banners.first;
      expect(b1.redirect, 'https://lello.com.br');
      expect(b1.redirectType, 'url');
      expect(b1.name, 'Banner 1');
      expect(b1.subTitle, 'Subtítulo 1');
      expect(b1.observacao, 'obs');
      expect(b1.image, 'img1.png');
      expect(b1.feature, 'boletos');
      expect(b1.location, 'HOME');
      expect(b1.typeBanner, 'carousel');
      expect(b1.projeto, 'MORAR');
      expect(b1.ordem, 1);
      expect(b1.ativo, 'S');
      expect(b1.arg!.partnerId, 'p1');
      expect(b1.lastUpdateAt, isNotNull);
      // O args é gravado mesmo sem partnerId.
      expect(banners.last.arg, isNotNull);
      expect(banners.last.arg!.partnerId, isNull);

      expect(await local.select('OUTRO'), isEmpty);
    });

    test('save nulo limpa o condomínio e devolve nulo', () async {
      final local = hiveLocalDataSource();
      await local.save([buildBannerModel(id: 'b1')], 'C1');
      await local.save([buildBannerModel(id: 'b9')], 'C2');

      expect(await local.save(null, 'C1'), isNull);
      expect(await local.select('C1'), isEmpty);
      expect((await local.select('C2')).single.id, 'b9');
    });

    test('save substitui os banners anteriores do condomínio', () async {
      final local = hiveLocalDataSource();
      await local.save([buildBannerModel(id: 'b1')], 'C1');
      await local.save([buildBannerModel(id: 'b2')], 'C1');
      expect((await local.select('C1')).map((b) => b.id), ['b2']);
    });

    test('banner sem args no Hive vem com arg nulo', () async {
      final dao = BannersDao();
      await dao.insert(BannersHive()
        ..id = 'solto'
        ..condominiumId = 'C1'
        ..image = 'x.png');
      final local = hiveLocalDataSource();
      final banners = await local.select('C1');
      expect(banners.single.id, 'solto');
      expect(banners.single.arg, isNull);
    });
  });

  group('BannersRemoteDataSourceImpl', () {
    test('lista os banners e marca lastUpdateAt', () async {
      final harness = BannersHarness();
      harness.stubBanners([bannerJson(id: 'b1'), bannerJson(id: 'b2')]);
      final before = DateTime.now();

      final result = await harness.remote.getBanners('C1');

      expect(result.map((b) => b.id), ['b1', 'b2']);
      expect(result.first.lastUpdateAt!.isBefore(before), isFalse);
      expect(harness.requestedPaths, ['/condominiums/C1/banners/v2']);
    });

    test('erro da API lança', () async {
      final harness = BannersHarness();
      harness.http.failAll();
      expect(() => harness.remote.getBanners('C1'), throwsA(anything));
    });
  });

  group('BannersRepositoryImpl', () {
    setUpAll(() async {
      await setUpFakeFirebase();
    });

    test('getBanners salva no cache e monta a urlImage', () async {
      final harness = BannersHarness();
      harness.stubBanners([bannerJson(id: 'b1'), bannerJson(id: 'b2', image: '')]);

      final result = await harness.repository.getBanners('C1');
      final banners = (result as Success<List<BannerEntity>>).get();
      expect(banners.first.urlImage, '/condominiums/C1/banners/b1/image/img1.png');
      // Sem imagem não monta a URL.
      expect(banners.last.urlImage, isNull);
      await Future<void>.delayed(Duration.zero);
      final memory = harness.local as MemoryBannersLocalDataSource;
      expect(memory.saved, ['C1']);
      expect(memory.store['C1'], hasLength(2));
    });

    test('getBanners com erro devolve Rejection', () async {
      final harness = BannersHarness();
      harness.http.failAll();
      final result = await harness.repository.getBanners('C1');
      expect(result, isA<Rejection>());
      expect((result as Rejection).get(), isA<UnknownFailure>());
    });

    test('selectFromCache devolve as entidades ou Rejection', () async {
      final memory = MemoryBannersLocalDataSource();
      memory.store['C1'] = [buildBannerModel(id: 'b1')];
      final harness = BannersHarness(local: memory);

      final ok = await harness.repository.selectFromCache('C1');
      expect((ok as Success<List<BannerEntity>>).get().single.urlImage,
          '/condominiums/C1/banners/b1/image/img1.png');

      final vazio = await harness.repository.selectFromCache('C2');
      expect((vazio as Success<List<BannerEntity>>).get(), isEmpty);

      memory.failSelect = true;
      final erro = await harness.repository.selectFromCache('C1');
      expect(erro, isA<Rejection>());
    });

    test('integração: remoto → Hive → cache', () async {
      final dir = initHiveTemp();
      addTearDown(() => disposeHive(dir));
      final harness = BannersHarness(local: hiveLocalDataSource());
      harness.stubBanners([bannerJson(id: 'b1', redirectType: 'whatsapp')]);

      await harness.repository.getBanners('C1');
      // O save do cache não é aguardado pelo repositório.
      await Future<void>.delayed(const Duration(milliseconds: 200));

      final cached = await harness.repository.selectFromCache('C1');
      final banner = (cached as Success<List<BannerEntity>>).get().single;
      expect(banner.id, 'b1');
      expect(banner.redirectType, BannerRedirectTypeEnum.whatsapp);
      expect(banner.arg!.partnerId, 'p1');
      expect(banner.urlImage, '/condominiums/C1/banners/b1/image/img1.png');
    });
  });

  group('GetBannersUseCaseImpl', () {
    test('valida o condomínio e escolhe a origem', () async {
      final memory = MemoryBannersLocalDataSource();
      memory.store['C1'] = [buildBannerModel(id: 'cache')];
      final harness = BannersHarness(local: memory);
      harness.stubBanners([bannerJson(id: 'remoto')]);

      final invalid = await harness.useCase
          .call(GetBannersParam(condominiumId: '', origin: DataOrigin.remote));
      expect((invalid as Rejection).get(), isA<InvalidParamFailure>());
      expect(harness.http.requests, isEmpty);

      final local = await harness.useCase
          .call(GetBannersParam(condominiumId: 'C1', origin: DataOrigin.local));
      expect((local as Success<List<BannerEntity>>).get().single.id, 'cache');
      expect(harness.http.requests, isEmpty);

      final remote = await harness.useCase
          .call(GetBannersParam(condominiumId: 'C1', origin: DataOrigin.remote));
      expect((remote as Success<List<BannerEntity>>).get().single.id, 'remoto');
      expect(harness.requestedPaths, ['/condominiums/C1/banners/v2']);
    });
  });
}
