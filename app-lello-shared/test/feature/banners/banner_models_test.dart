import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/banners/data/model/banner_args_model.dart';
import 'package:shared_features/feature/banners/data/model/banner_model.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_args.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_location_enum.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_redirect_enum.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_redirect_type_enum.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_type_enum.dart';

import 'banners_support.dart';

void main() {
  group('BannerArgsModel', () {
    test('json e entidade', () {
      final model = BannerArgsModel.fromJson({'partner_id': 'p9'});
      expect(model.partnerId, 'p9');
      expect(model.toJson(), {'partner_id': 'p9'});
      expect(model.toEntity().partnerId, 'p9');
      expect(BannerArgsModel.fromEntity(BannerArgs(partnerId: 'x'))!.partnerId,
          'x');
      expect(BannerArgsModel.fromEntity(null), isNull);
    });
  });

  group('BannerModel', () {
    test('fromJson lê tudo e toJson devolve os mesmos valores', () {
      final json = bannerJson(lastUpdateAt: '2026-01-02T03:04:05.000');
      final model = BannerModel.fromJson(json);
      expect(model.id, 'b1');
      expect(model.redirect, 'https://lello.com.br');
      expect(model.redirectType, 'url');
      expect(model.name, 'Banner 1');
      expect(model.subTitle, 'Subtítulo 1');
      expect(model.observacao, 'obs');
      expect(model.image, 'img1.png');
      expect(model.urlImage, isNull);
      expect(model.feature, 'boletos');
      expect(model.location, 'HOME');
      expect(model.typeBanner, 'carousel');
      expect(model.arg!.partnerId, 'p1');
      expect(model.projeto, 'MORAR');
      expect(model.ordem, 1);
      expect(model.ativo, 'S');
      expect(model.lastUpdateAt, DateTime(2026, 1, 2, 3, 4, 5));

      final back = model.toJson();
      expect(back['arg'], isA<BannerArgsModel>());
      back['arg'] = (back['arg'] as BannerArgsModel).toJson();
      expect(back, json);
    });

    test('toEntity converte os enums e fromEntity volta', () {
      final entity = buildBannerModel().toEntity();
      expect(entity.id, 'b1');
      expect(entity.redirectType, BannerRedirectTypeEnum.url);
      expect(entity.feature, BannerFeatureEnum.boletos);
      expect(entity.location, BannerLocationEnum.home);
      expect(entity.typeBanner, BannerTypeEnum.carousel);
      expect(entity.arg!.partnerId, 'p1');
      expect(entity.subtitle, 'Subtítulo 1');
      expect(entity.ordem, 1);
      expect(entity.ativo, 'S');

      final model = BannerModel.fromEntity(entity)!;
      expect(model.redirectType, 'url');
      expect(model.feature, 'boletos');
      expect(model.location, 'home');
      expect(model.typeBanner, 'carousel');
      expect(model.arg!.partnerId, 'p1');
      expect(model.subTitle, 'Subtítulo 1');
      expect(BannerModel.fromEntity(null), isNull);

      final semArg = BannerModel.fromEntity(buildBanner(partnerId: null))!;
      expect(semArg.arg, isNull);
      expect(semArg.toEntity().arg, isNull);
    });

    test('redirectType aceita variações e cai em other', () {
      BannerRedirectTypeEnum parse(String? v) =>
          buildBannerModel(redirectType: v).toEntity().redirectType;
      expect(parse('url'), BannerRedirectTypeEnum.url);
      expect(parse('URL'), BannerRedirectTypeEnum.url);
      expect(parse(' whatsapp '), BannerRedirectTypeEnum.whatsapp);
      expect(parse('FEATURE'), BannerRedirectTypeEnum.feature);
      expect(parse('desconhecido'), BannerRedirectTypeEnum.other);
      expect(parse(''), BannerRedirectTypeEnum.other);
      expect(parse(null), BannerRedirectTypeEnum.other);
    });

    test('feature normaliza os aliases do backend', () {
      BannerFeatureEnum parse(String? v) =>
          buildBannerModel(feature: v).toEntity().feature;
      expect(parse('LELLO_MORAR_COMODIDADES_PARCEIRO'),
          BannerFeatureEnum.lelloMorarComfortPartner);
      expect(parse('LELLO_MORAR_SEGUROS'), BannerFeatureEnum.lelloMorarInsurance);
      expect(parse('LELLO_MORAR_TDB'), BannerFeatureEnum.lelloMorarTDB);
      expect(parse('GESTAO_TECNICA'), BannerFeatureEnum.gestaoTecnica);
      expect(parse('OUTROS'), BannerFeatureEnum.others);
      expect(parse('acordos'), BannerFeatureEnum.acordos);
      expect(parse('ASSEMBLEIA'), BannerFeatureEnum.assembleia);
      expect(parse('bella'), BannerFeatureEnum.bella);
      expect(parse('nao_existe'), BannerFeatureEnum.others);
      expect(parse(''), BannerFeatureEnum.others);
      expect(parse(null), BannerFeatureEnum.others);
    });

    test('typeBanner: nulo, conhecido e desconhecido', () {
      BannerTypeEnum? parse(String? v) =>
          buildBannerModel(typeBanner: v).toEntity().typeBanner;
      expect(parse(null), isNull);
      expect(parse(''), isNull);
      expect(parse('INDIVIDUAL'), BannerTypeEnum.individual);
      expect(parse('Carousel'), BannerTypeEnum.carousel);
      expect(parse('xpto'), BannerTypeEnum.other);
    });

    test('location normaliza os aliases e devolve nulo para desconhecido', () {
      BannerLocationEnum? parse(String? v) =>
          buildBannerModel(location: v).toEntity().location;
      expect(parse('HOME'), BannerLocationEnum.home);
      expect(parse('CONDOMINIO_E_EU'), BannerLocationEnum.condominioEEu);
      expect(parse('EMPRESA_E_EU'), BannerLocationEnum.empresaEEu);
      expect(parse('COMODIDADES'), BannerLocationEnum.comodidades);
      expect(parse('RESOLVA_FACIL'), BannerLocationEnum.resolvaFacil);
      expect(parse('MINHA_UNIDADE'), BannerLocationEnum.minhaUnidade);
      expect(parse('minhaUnidade'), BannerLocationEnum.minhaUnidade);
      expect(parse('outro_lugar'), isNull);
      expect(parse(''), isNull);
      expect(parse(null), isNull);
    });
  });

  test('BannerEntity tem os defaults esperados', () {
    final entity = buildBanner();
    expect(entity.redirectType, BannerRedirectTypeEnum.url);
    final minimal = BannerEntityFactory.minimal();
    expect(minimal.redirectType, BannerRedirectTypeEnum.other);
    expect(minimal.feature, BannerFeatureEnum.others);
    expect(minimal.location, isNull);
    expect(BannerLocationEnum.values, hasLength(6));
    expect(BannerTypeEnum.values, hasLength(3));
    expect(BannerRedirectTypeEnum.values, hasLength(4));
  });
}

class BannerEntityFactory {
  static minimal() => buildBanner(
      redirectType: BannerRedirectTypeEnum.other,
      feature: BannerFeatureEnum.others,
      location: null);
}
