import 'package:essentials/essentials.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/feature/banners/data/model/banner_args_model.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_location_enum.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_redirect_enum.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_redirect_type_enum.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_type_enum.dart';

import '../../domain/entity/banner.dart';

part 'banner_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BannerModel {
  String id;
  String? redirect;
  String? redirectType;
  String? name;
  String? subTitle;
  String? observacao;
  String image;
  String? urlImage;
  String? feature;
  String? location;
  String? typeBanner;
  BannerArgsModel? arg;
  String? projeto;
  int? ordem;
  String? ativo;
  DateTime? lastUpdateAt;

  BannerModel({
    required this.id,
    this.redirect,
    this.redirectType,
    this.name,
    this.subTitle,
    this.observacao,
    required this.image,
    this.urlImage,
    this.feature,
    this.location,
    this.typeBanner,
    this.arg,
    this.projeto,
    this.ordem,
    this.ativo,
    this.lastUpdateAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);

  Map<String, dynamic> toJson() => _$BannerModelToJson(this);

  static BannerModel? fromEntity(BannerEntity? entity) => entity == null
      ? null
      : (BannerModel(
          image: entity.image,
          urlImage: entity.urlImage,
          id: entity.id,
          redirect: entity.redirect,
          redirectType: enumToString(entity.redirectType),
          name: entity.name,
          subTitle: entity.subtitle,
          observacao: entity.observacao,
          feature: enumToString(entity.feature),
          location: enumToString(entity.location),
          typeBanner: enumToString(entity.typeBanner),
          arg: BannerArgsModel.fromEntity(entity.arg),
          projeto: entity.projeto,
          ordem: entity.ordem,
          ativo: entity.ativo,
          lastUpdateAt: entity.lastUpdateAt));

  BannerEntity toEntity() => BannerEntity(
      image: this.image,
      urlImage: this.urlImage,
      id: this.id,
      redirect: this.redirect,
      redirectType: _parseRedirectType(this.redirectType),
      name: this.name,
      subtitle: this.subTitle,
      observacao: this.observacao,
      feature: _parseFeature(this.feature),
      location: _parseLocation(this.location),
      typeBanner: _parseTypeBanner(this.typeBanner),
      arg: this.arg?.toEntity(),
      projeto: this.projeto,
      ordem: this.ordem,
      ativo: this.ativo,
      lastUpdateAt: this.lastUpdateAt);

  BannerRedirectTypeEnum _parseRedirectType(String? value) {
    final raw = value?.trim();
    if (raw == null || raw.isEmpty) {
      return BannerRedirectTypeEnum.other;
    }

    return stringToEnum(BannerRedirectTypeEnum.values, raw) ??
        stringToEnum(BannerRedirectTypeEnum.values, raw.toUpperCase()) ??
        stringToEnum(BannerRedirectTypeEnum.values, raw.toLowerCase()) ??
        BannerRedirectTypeEnum.other;
  }

  BannerFeatureEnum _parseFeature(String? value) {
    final raw = value?.trim();
    if (raw == null || raw.isEmpty) {
      return BannerFeatureEnum.others;
    }

    final normalized = _normalizeFeatureAlias(raw);

    return stringToEnum(BannerFeatureEnum.values, normalized) ??
        stringToEnum(BannerFeatureEnum.values, normalized.toUpperCase()) ??
        stringToEnum(BannerFeatureEnum.values, normalized.toLowerCase()) ??
        BannerFeatureEnum.others;
  }

  BannerTypeEnum? _parseTypeBanner(String? value) {
    final raw = value?.trim();
    if (raw == null || raw.isEmpty) return null;

    return stringToEnum(BannerTypeEnum.values, raw) ??
        stringToEnum(BannerTypeEnum.values, raw.toUpperCase()) ??
        stringToEnum(BannerTypeEnum.values, raw.toLowerCase()) ??
        BannerTypeEnum.other;
  }

  BannerLocationEnum? _parseLocation(String? value) {
    final raw = value?.trim();
    if (raw == null || raw.isEmpty) {
      return null;
    }

    final normalized = _normalizeLocationAlias(raw);

    return stringToEnum(BannerLocationEnum.values, normalized) ??
        stringToEnum(BannerLocationEnum.values, normalized.toUpperCase()) ??
        stringToEnum(BannerLocationEnum.values, normalized.toLowerCase());
  }

  String _normalizeFeatureAlias(String raw) {
    switch (raw.toUpperCase()) {
      case 'LELLO_MORAR_COMODIDADES_PARCEIRO':
        return 'lelloMorarComfortPartner';
      case 'LELLO_MORAR_SEGUROS':
        return 'lelloMorarInsurance';
      case 'LELLO_MORAR_TDB':
        return 'lelloMorarTDB';
      case 'GESTAO_TECNICA':
        return 'gestaoTecnica';
      case 'OUTROS':
        return 'others';
      default:
        return raw;
    }
  }

  String _normalizeLocationAlias(String raw) {
    switch (raw.toUpperCase()) {
      case 'HOME':
        return 'home';
      case 'CONDOMINIO_E_EU':
        return 'condominioEEu';
      case 'EMPRESA_E_EU':
        return 'empresaEEu';
      case 'COMODIDADES':
        return 'comodidades';
      case 'RESOLVA_FACIL':
        return 'resolvaFacil';
      case 'MINHA_UNIDADE':
        return 'minhaUnidade';
      default:
        return raw;
    }
  }
}
